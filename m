Return-Path: <linux-kernel-owner+w=401wt.eu-S933547AbZJHU46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547AbZJHU46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933445AbZJHU44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:56:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:31217 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933407AbZJHU4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:56:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=VEqvqkaJZlnoqjHTNMoc4v0vvTdsCxkid9HObhTPZyxd+/bRjGIweX8iz/MmOUEr6A
         vna/pv9MFy7Nn1J+h7l3vZ1YOsxZNHBQ0nT/E49ZU+oNwilHZluiJRfbVV1lpzOrbOZt
         SfwYujZFi1EfU5C3BDPGhqUaV3+Zjzpvpiof8=
Message-ID: <4ACE51A8.3030406@gmail.com>
Date: Thu, 08 Oct 2009 22:55:04 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.7 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: akpm@linux-foundation.org, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/8] FS: proc, make limits writable
References: <20090903174106.GC27161@redhat.com> <1252008524-5376-8-git-send-email-jirislaby@gmail.com> <20090904142645.GA10535@redhat.com>
In-Reply-To: <20090904142645.GA10535@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 04:26 PM, Oleg Nesterov wrote:
> One small nit, just to suggest the further 9/8 cleanup,
> 
>> +static const struct file_operations proc_pid_limits_operations = {
>> +	.read		= proc_info_read,
>> +	.write		= limits_write,
>> +};
> 
> I think it makes sense to tweak proc_pid_limits() a little bit (and
> rename it), so that we can do
> 
> 	.read = limits_read,
> 	.write = limits_write
> 
> Then,
> 
>> @@ -2501,7 +2571,9 @@ static const struct pid_entry tgid_base_stuff[] = {
>> +	NOD("limits",	  S_IFREG|S_IRUSR|S_IWUSR, NULL,
>> +			&proc_pid_limits_operations,
>> +			{ .proc_read = proc_pid_limits }),
> 
> We could use
> 
> 	REG("limits", S_IRUSR|S_IWUSR, &proc_pid_limits_operations),
> 
> instead, this looks a bit cleaner to me.

Hi again, nobody picked them up yet, I waited till the end of the merge
window and now I'll repost.

Did you mean here to do the proc_info_read work (get/put task, alloc
buf, simple_read) directly in limits_read?

> And another minor nit (just in case you will re-submit this series for
> some reason). Perhaps the changelog in 6/8 should mention that we do
> not do any security checks when tsk != current (without selinux). We
> assume that either the caller is sys_setrlimit(), or the caller should
> verify it has rights to change the limits: in case of limits_write()
> we rely on ->mode = S_IRUSR|S_IWUSR.

I did it as a comment by the setrlimit. I think nobody would care about
a changelog note ;).

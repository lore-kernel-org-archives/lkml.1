Return-Path: <linux-kernel-owner+w=401wt.eu-S1755851AbYJNBOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851AbYJNBOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 21:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYJNBOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 21:14:22 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:24208 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbYJNBOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 21:14:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=UfI5ppSmPZFh/KFHL1bRvXcVJBPcIjNPwINfCefef24VETcbVdBdTFGUokVwPX1N5j
         xM+wZ34HM0IT8djiXlg63NPZc2dvMznk4ZeSIoaHI3/218+NfZSH5ZACvVzDLTmnfbsw
         l/GJuzM1jXsNBDlWIN4kKu4ghV4oxpw5lM/ww=
Message-ID: <86802c440810131814l42340448w7d2158f4bfdda504@mail.gmail.com>
Date: Mon, 13 Oct 2008 18:14:21 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
Cc: "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <48F3F014.3050406@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081014005428.EC2D8DDF93@ozlabs.org> <48F3F014.3050406@zytor.com>
X-Google-Sender-Auth: 9d00e3f90798aaae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 6:04 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Benjamin Herrenschmidt wrote:
>>
>> That debug outpout in kernel/resource.c is busted on 32-bit
>> machines, fix it with appropriate casts.
>>
>> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> ---
>>
>> One day Yinghai will figure out that resource_size_t can be 32-bit
>> and thus as printk arguments must be cast to (unsigned long long)
>> explicitely when using %llx... hopefully, that day, Ingo will also
>> catch these before committing them as it's not the first one like
>> this :-)

we had patch to remove that two debug lines.

>>
>
> I really think Linus' solution (add a resource printf modifier, that can
> contain the whole format) is much better.

yes. some pci resource print out etc could use that too.
to get rid of the annoying casting.

BTW: can you just enforce resource_t to u64?

YH

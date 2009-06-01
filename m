Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZFAJ7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZFAJ7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZFAJ7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:59:46 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:33918 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699AbZFAJ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:59:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QThF51tss3vD+DIKSmrDiuGdLIxQVCmwIH2UFFgadsUv2V9rJmuqOn9WOEuLqwOOEz
         b3PvR4DC1SFE/UXkVOYDh8H63zRfiylKTTS5Mp0tanADcLPu+pALgC8vSNvkj1Dyj2iA
         vJ974O48+O6/0BfUKZr5jYzOl8EZHJfZ0oyc0=
Message-ID: <4A23A690.6070504@gmail.com>
Date: Mon, 01 Jun 2009 11:59:44 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1pre) Gecko/20090525 SUSE/3.0b2-10.1 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: vibi_sreenivasan@cms.com
CC: Mimi Zohar <zohar@us.ibm.com>, Kylene Hall <kylene@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Reiner Sailer <sailer@watson.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>
Subject: Re: [Fwd: Re: [PATCH]:RESEND : Return proper error value on failure
 of dentry_open]
References: <1243849610.2234.3.camel@system>
In-Reply-To: <1243849610.2234.3.camel@system>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2009 11:46 AM, vibi sreenivasan wrote:
>>>>  	mutex_unlock(&iint->mutex);
>>>> -	if (file)
>>>> +	if (!IS_ERR(file))
>>>>  		fput(file);
>>>
>>> No, IS_ERR won't catch NULL and there is 'file = NULL' on the
>>> dentry_open fail path.
> Can you please point out that line number in fs/open.c

Aha, you use linus's git. This has been fixed by
f06dd16a03f6f7f72fab4db03be36e28c28c6fd6
(IMA: Handle dentry_open failures)
in -next.

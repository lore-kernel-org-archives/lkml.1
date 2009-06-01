Return-Path: <linux-kernel-owner+w=401wt.eu-S1757278AbZFAKCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278AbZFAKCb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 06:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbZFAKCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 06:02:23 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:41188 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbZFAKCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:02:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EYDBnJKbqyeg+RCjpRyPtAjcS2ZUNQPp7ZGHsRdgPc82IsrsVN8mu0vJOkJMCq6LiY
         ofiR8iXD2u3jAhiFPpnalzXXuU05v8PPI+4kHGBH0KxIXx0EnpO/Rwtmvt4n44+0v5/9
         0T161Ar6q8bpWyKcFW9Cl0nDOWHNaw5M6GTJA=
Message-ID: <4A23A72E.3020506@gmail.com>
Date: Mon, 01 Jun 2009 12:02:22 +0200
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
References: <1243849610.2234.3.camel@system> <4A23A690.6070504@gmail.com>
In-Reply-To: <4A23A690.6070504@gmail.com>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2009 11:59 AM, Jiri Slaby wrote:
> On 06/01/2009 11:46 AM, vibi sreenivasan wrote:
>>>>>  	mutex_unlock(&iint->mutex);
>>>>> -	if (file)
>>>>> +	if (!IS_ERR(file))
>>>>>  		fput(file);
>>>>
>>>> No, IS_ERR won't catch NULL and there is 'file = NULL' on the
>>>> dentry_open fail path.
>> Can you please point out that line number in fs/open.c
> 
> Aha, you use linus's git. This has been fixed by
> f06dd16a03f6f7f72fab4db03be36e28c28c6fd6
> (IMA: Handle dentry_open failures)
> in -next.

[But the fix in -next still misses 'return 0' -> 'return rc' which I
though you had tried to change.]

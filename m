Return-Path: <linux-kernel-owner+w=401wt.eu-S1752942AbZHTITK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbZHTITK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 04:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbZHTITJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 04:19:09 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:61586 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbZHTITI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 04:19:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mlqkbiBGTBFP/2LoYO6DfxVOlCrSdxYF/+/wk4EmGioojcyQlRtpAXge40xJwGpp15
         5ToCydygY832+T4XsKD904Q/SPJngbv44SN5vamEZHMk9SGxOkRE1ylJsO1zhKPjZJbW
         A7FQK2xKF1tSddWGVFWMz0bsrBM6ElD40rbS0=
MIME-Version: 1.0
In-Reply-To: <m17hwyhq49.fsf@fess.ebiederm.org>
References: <m163cjhwa4.fsf@fess.ebiederm.org>
	 <m1skfnggrb.fsf@fess.ebiederm.org>
	 <a8e1da0908200054t456265b4ta698ba204b5aedc8@mail.gmail.com>
	 <m17hwyhq49.fsf@fess.ebiederm.org>
Date: Thu, 20 Aug 2009 16:19:08 +0800
Message-ID: <a8e1da0908200119u83c965bgf08996b0aa4aca52@mail.gmail.com>
Subject: Re: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer 
	dereference at 0000000000000008
From: Dave Young <hidave.darkstar@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 4:00 PM, Eric W. Biederman<ebiederm@xmission.com> wrote:
> Dave Young <hidave.darkstar@gmail.com> writes:
>
>> On Thu, Aug 20, 2009 at 2:07 PM, Eric W. Biederman<ebiederm@xmission.com> wrote:
>>>
>>> ebiederm@xmission.com (Eric W. Biederman) writes:
>>>
>>>> I'm not certain who I should route this too, but I just had 2.6.31-rc6
>>>> fall over on me.  I don't know how reproducible this will be but
>>>> I have a full crash dump if someone is interested in looking into this.
>>>
>>> Looks like I was wrong.  This is appears trivial to reproduce,
>>> I have just reproduced it two more times in a row.  I think
>>> the problem is pty related.
>>>
>>> I was looking into a change in behavior on 2.6.31-rc6 where
>>> data was being lost, and it appears one variant of my test program
>>> kills the kernel.
>>>
>>> The following program run as an unprivileged user causes a kernel
>>> panic in about a minute:
>>>
>>> aka
>>>
>>> while :; do ./KernelTtyTest ; done
>>
>> The test app failed for me:
>>
>> read failed: Input/output error
>> lastbytes: '\r\nprocess_cmd read failed: Interrupted system
>> call\r\necho _2_\r\n'
>> Aborted
>
>
> Oh.  It definitely fails.  I just found that when it failed
> about 600 times in a row it took my kernel with it.  I was
> developing it to understand tty interactions, and when I realized
> that the version I had was killing my kernel I sent it out
> as it was a nice self contained test case.

Confirm: I can reproduce on i386 machine.

>
> Eric
>



-- 
Regards
dave

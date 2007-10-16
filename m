Return-Path: <linux-kernel-owner+w=401wt.eu-S935556AbXJPU3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935556AbXJPU3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751014AbXJPU3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:29:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:51537 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbXJPU3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:29:24 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Power button policy and mechanism
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>,
       linux-main <linux-kernel@vger.kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>
Reply-To: 7eggert@gmx.de
Date: Tue, 16 Oct 2007 22:29:15 +0200
References: <9eSWm-5sS-7@gated-at.bofh.it> <9eVKz-1xq-17@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1Iht2R-0001Yr-NW@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX18FOTYUaKW8vkedhzBliFvmNh2uL2b2w37It5d
 rga9sCB7uS1JW3VrmnpoTorUJao/JkiFoyyDE85CEugogQUe6N
 b9bkIXvN2S3vsTH24aQ+Q==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On 10/16/07, Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:

>> Is the suggested approach on handling powerbutton (in keyboard driver) to
>> simply push out the event and let userland handle it?
> 
> Yes.
> 
>> The reason Im asking this is because as you might know Im maintainer for two
>> mini-laptop style pda's (HP7xx & HP6xx) and it would simplify my life alot if
>> I didn't need to depend on userland applications to be able to
>> suspend/resume.
>>
>> For instance HP6XX receives an interrupt call whenever the powerbutton is
>> pressed. Now I could just push out the event and let another program handle
>> it but considering it would take a minimum amount of lines to let it simply
>> suspend/resume I feel its a waste.
>>
>> Previously the hp6xx has been allowed to do this "policy" way but that was
>> when LinuxSH stod as a side branch to main tree. Now when everything gets
>> merged into mainline I need to decide how to do this.
>>
>> This is mainly an embedded issue, but I feel it's quite important. It should
>> apply to other devices also like for example Zaurus branches (those with
>> keyboard and designated power button).
>>
>> So in short:
>> 1. Does mainline policy allow static power button events inside kernel (power
>> button == suspend/resume)?
>>        Why/Why Not?
> 
> Could it be that you may want to prevent suspend from happening? Or
> delay it until system completes some important operation?

If I want to prevent the suspend/shutdown from happening, I don't press
the button. If my system insists on not shutting down in order to instead
run out to power while doing something important - I'm not happy, too.

OTOH, maybe you could allocate the storage for the suspend image here instead
of creating HUGE swap space and letting the kernel prevent suspend by using
it or watching the kernel thrash for hours before each OOM.

> Do something
> else, like cleanly disconnect your network connections?

Not needed, possibly not desired.

> With actual
> handling done in userspace it's all possible. With suspend done
> directly in kernel it is much harder and couples input subsystem with
> power management too tightly.

You can do something like control_alt_delete() - in fact I'm dedicating
400 KB of RAM for "kill -INT 1" on my desktop, not using suspend. Having
an ACPI userspace event is not bad if you intend to use it, but for people
who just want shutdown or suspend to happen, it's overkill.
-- 
Top 100 things you don't want the sysadmin to say:
79. What's this "any" key I'm supposed to press?

Friﬂ, Spammer: v@7eggert.dyndns.org 3dvkv3To@ifmpc.7eggert.dyndns.org

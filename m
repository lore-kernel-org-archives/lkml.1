Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZKTJ3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZKTJ3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZKTJ3C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:29:02 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:43080 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZKTJ3A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:29:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pPByt7wlmbAmhG/rz3UQ2N1rbOGFyE0f9NPV+rmgRtkLcuw1VvKubh0wwqY0KR/85d
         WAFG9O4BFS3En9quTgj9G5izO+jmI1mSflCyMuqehmHr9KHHKrBeDRwhXB5lhKIVeYgP
         BGkmyX4KFb1gruLVf6mPntOzDGAUSVv/aY+2U=
MIME-Version: 1.0
In-Reply-To: <4B065648.6040609@garzik.org>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
	 <xXQGFmujPl.A.n7F.4SdALB@chimera>
	 <20091119.120550.183823935.davem@davemloft.net>
	 <40a4ed590911192359o563b104fo562f325ad9f5358e@mail.gmail.com>
	 <4B065648.6040609@garzik.org>
Date: Fri, 20 Nov 2009 10:29:03 +0100
Message-ID: <40a4ed590911200129p6f0d048dqef10df2b311d4744@mail.gmail.com>
Subject: Re: [Bug #14622] Second IDE device not found
From: Zeno Davatz <zdavatz@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: David Miller <davem@davemloft.net>, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 9:41 AM, Jeff Garzik <jeff@garzik.org> wrote:
> On 11/20/2009 02:59 AM, Zeno Davatz wrote:
>>
>> On Thu, Nov 19, 2009 at 9:05 PM, David Miller<davem@davemloft.net>  wrote:
>>>
>>> From: "Rafael J. Wysocki"<rjw@sisk.pl>
>>> Date: Mon, 16 Nov 2009 23:37:47 +0100 (CET)
>>>
>>>> This message has been generated automatically as a part of a report
>>>> of recent regressions.
>>>>
>>>> The following bug entry is on the current list of known regressions
>>>> from 2.6.31.  Please verify if it still should be listed and let me know
>>>> (either way).
>>>>
>>>>
>>>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=14622
>>>> Subject               : Second IDE device not found
>>>> Submitter     : Zeno Davatz<zdavatz@gmail.com>
>>>> Date          : 2009-11-11 17:31 (6 days old)
>>>> References    : http://marc.info/?l=linux-kernel&m=125796105822353&w=4
>>>
>>> We're going to need more information to diagnose this.
>>>
>>> And linux-ide should have been at least CC:'d from the very
>>> beginning.
>>>
>>>  From what I can discern the problem is introduced somewhere between
>>> 2.6.27 and 2.6.31, you have a Serverworks CSB5 and primarily the issue
>>> is that attaching or detaching your CD-ROM driver influences whether
>>> both of your disks are properly detected.  Correct?
>>>
>>> You seem to have played around with using the IDE layer vs. the
>>> ATA layer.  Can you see any difference in behavior if you try
>>> using just the IDE layer vs. just the ATA layer with the 2.6.31
>>> kernel?
>>
>> Please see:
>>
>> http://www.flickr.com/photos/zrr/4118682747/
>>
>> and
>>
>> http://www.flickr.com/photos/zrr/4119453092/
>
> Unfortunately, both of these photos only show that MD (block major 9) device
> could not be found for root.
>
> For either ATA or IDE, we would need to see full dmesg somehow -- perhaps
> capturing serial console output?  (Documentation/serial-console.txt)

Ok, I appended

console=ttyS1,9600 console=tty0

to the kernel command line at lilo after choosing the kernel image and
I get a ton of output. But how to I save the output to a file?

>> I makes no difference if I choose ATA or only IDE.
>>
>> I am also attaching you my Kernel .config
>>
>> I could also test with 2.6.32-rc8 (torvalds-git)
>>
>> I suggest you send me two .config that I can both test with 2.6.31.6
>
> I bet libata fails because CONFIG_BLK_DEV_SD is not enabled.  Probably want
> to enable CONFIG_BLK_DEV_SR too, for libata CD-ROM support.  I would be
> interested to see your failing ATA config, with IDE disabled.

I enabled CONFIG_BLK_DEV_SR. Do you want above test with or without

CONFIG_BLK_DEV_SVWKS (OSB4/CSB5) enabled?

Best
Zeno

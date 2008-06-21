Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbYFUOS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbYFUOS3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 10:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYFUOSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 10:18:18 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:52842 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbYFUOSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 10:18:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O+7T8Y6cl+cmrLSekgw2bsTsEAVSQFxDRxt2Pvsv10MzwCyw22mfPWCPzggQRcz0Y+
         kfllEZAGhOEE765iKlgkcjXINVNVE1296fwtWrIo9TL8DP2T3gf8RWoFAS4mw0TE/WBN
         PvzHdXu02+No/tQz8tLt7BtgA3xBvw7Rh0wVU=
Message-ID: <5a4c581d0806210718m77be63c9l444d8d7d7a5266bd@mail.gmail.com>
Date: Sat, 21 Jun 2008 16:18:15 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after media change and delay
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
       linux-scsi@vger.kernel.org,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Maarten Bressers" <mbres@gentoo.org>, "Daniel Drake" <dsd@gentoo.org>,
       "Cell Broadband Engine OSS Development" <cbe-oss-dev@ozlabs.org>
In-Reply-To: <5a4c581d0806180515g5f24e9d9m85369bfa0a5f2228@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
	 <Pine.LNX.4.64.0806131932350.30730@vixen.sonytel.be>
	 <5a4c581d0806180147qf8fc731y527c79bfb73401b2@mail.gmail.com>
	 <Pine.LNX.4.64.0806181156460.13297@vixen.sonytel.be>
	 <5a4c581d0806180515g5f24e9d9m85369bfa0a5f2228@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[dropped David Martin from CC: list as I get permanent delivery errors]

On Wed, Jun 18, 2008 at 2:15 PM, Alessandro Suardi
<alessandro.suardi@gmail.com> wrote:
> On Wed, Jun 18, 2008 at 1:13 PM, Geert Uytterhoeven
> <Geert.Uytterhoeven@sonycom.com> wrote:
>> On Wed, 18 Jun 2008, Alessandro Suardi wrote:
>>> On Fri, Jun 13, 2008 at 7:33 PM, Geert Uytterhoeven
>>> <Geert.Uytterhoeven@sonycom.com> wrote:
>>> > On Fri, 6 Jun 2008, Geert Uytterhoeven wrote:
>>> >> When mounting a CD/DVD more than 30 seconds after inserting it, and reading
>>> >> from it, we get:
>>> >
>>> > Apparently the fix didn't make it to all the CCed lists...
>>> >
>>> > http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Fjejb%2Fscsi-rc-fixes-2.6.git;a=commitdiff_plain;h=d1daeabf0da5bfa1943272ce508e2ba785730bf0
>>>
>>> Oh, that's in mainline ? I still have the problem of having to
>>
>> Not yet, it's in the scsi-rc-fixes-2.6 tree.
>>
>>>  insert DVD / try accessing it and get errors / eject / re-insert
>>>  and then it magically works... the messages have changed
>>>  from what they were as reported here
>>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=10116
>>>
>>>  (see comments #8 and #9) to these ones, in 2.6.26-rc6-git4:
>>>
>>> Jun 17 22:38:43 sandman kernel: sr 1:0:0:0: [sr0] Result:
>>> hostbyte=0x00 driverbyte=0x08
>>> Jun 17 22:38:43 sandman kernel: sr 1:0:0:0: [sr0] Sense Key : 0x3 [current]
>>> Jun 17 22:38:43 sandman kernel: sr 1:0:0:0: [sr0] ASC=0x11 ASCQ=0x0
>>> Jun 17 22:38:43 sandman kernel: end_request: I/O error, dev sr0, sector 232
>>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 29
>>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 30
>>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 31
>>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 32
>>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 33
>>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 34
>>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 35
>>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 36
>>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 37
>>> Jun 17 22:38:43 sandman kernel: Buffer I/O error on device sr0, logical block 38
>>>
>>> here I eject and reinsert the disc, and:
>>>
>>> Jun 17 22:39:10 sandman kernel: UDF-fs: No VRS found
>>>
>>>  lo and behold, no problem.
>>>
>>> This does not, alas, happen every time. It might be at the first
>>>  DVD access after booting the laptop, but I haven't investigated
>>>  in this detail yet.
>>
>> Does /sys/block/sr0/size reflect the correct size of the DVD?
>>
>> Did you try applying the patch?
>
> ATM I'm away from home (as usual), I'll post back when
>  I have the info you asked for and tried applying the
>  above patch. Thanks !

Sigh. I haven't been able to reproduce the problem once since
 I posted this. Will keep trying...

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')

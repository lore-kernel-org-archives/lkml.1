Return-Path: <linux-kernel-owner+w=401wt.eu-S1751943AbYJRSen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943AbYJRSen (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 14:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYJRSef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 14:34:35 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:61855 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYJRSee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 14:34:34 -0400
Message-ID: <f488382f0810181134h24ed5da8lc12e62816436bb5@mail.gmail.com>
Date: Sat, 18 Oct 2008 11:34:32 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Justin Mattock" <justinmattock@gmail.com>, "Jiri Slaby" <jslaby@suse.cz>,
       "Jiri Kosina" <jkosina@suse.cz>
Subject: Re: appletouch regression
Cc: "Sven Anders" <anders@anduras.de>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <dd18b0c30810181029r75f069a9h964254075dfd866f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f488382f0810180552w2078244eiaed1fa100ad4c4c6@mail.gmail.com>
	 <48F9E5EF.4080806@anduras.de>
	 <f488382f0810180944i4736a88cl136637261a16ffaa@mail.gmail.com>
	 <dd18b0c30810181029r75f069a9h964254075dfd866f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2008 at 10:29 AM, Justin Mattock
<justinmattock@gmail.com> wrote:
> On Sat, Oct 18, 2008 at 9:44 AM, Steven Noonan <steven@uplinklabs.net> wrote:
>> 2008/10/18 Sven Anders <anders@anduras.de>:
>>> Steven Noonan schrieb:
>>>> It seems that the appletouch driver is (sporadically) not detecting my
>>>> Apple Trackpad anymore on Linus' current tree (2.6.27-05577-g0cfd810).
>>>> When it is misbehaving, it doesn't have any /dev/input/event* entry
>>>> that corresponds to the input from appletouch, and dmesg -should- show
>>>> the following, as 2.6.27.1 does, but does not:
>>>>
>>>> appletouch: Geyser mode initialized.
>>>> input: appletouch as /class/input/input4
>>>> usbcore: registered new interface driver appletouch
>>>> appletouch: 17" model detected
>>>>
>>>> On the current tree, occasionally all I get is:
>>>>
>>>> usbcore: registered new interface driver appletouch
>>>>
>>>> It's unfortunately a touchy issue, as it only -occasionally- happens.
>>>> A bisection will be a pain in the butt, but I'm starting it right now
>>>> anyway.
>>>
>>> Hmm, strange...
>>>
>>> I didn't change anything in the initialization routines. But I will take a look
>>> into the changes, if something is missing or wrong...
>>>
>>
>> I am pretty sure the two patches recently submitted by you are not
>> guilty (I tried reverting both of them, which had no effect).
>>
>> Still working on the git-bisect. Fell asleep in the middle of it last night. O.o
>>
>> - Steven
>
> I too have a lifeless apple touchpad,
> not sure when this started,due to never really using
> it unless I'm in a remote location.
>

I finished the git-bisect. Here's the log:
 # bad:  [0cfd8103] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
 # good: [3fa8749e] Linux 2.6.27
 # good: [56c5d900] Merge branch 'master' of master.kernel.org:/pub/sc
 # good: [acd15a83] Merge branch 'upstream-linus' of git://git.kernel.
 # bad:  [c8d8a232] Merge git://git.kernel.org/pub/scm/linux/kernel/gi
 # bad:  [f055663c] checkpatch: report the correct lines for single st
 # good: [6dc64725] Merge commit 'origin'
 # bad:  [08da6f1b] MIPS: Kill unused <asm/debug.h> inclusions
 # bad:  [79575019] HID: convert to dev_* prints
 # bad:  [980a3da6] HID: move samsung quirks
 # bad:  [78a849a6] HID: move microsoft quirks
 # bad:  [022e8c4d] HID: move usage input mapping to hid.h
 # good: [85cdaf52] HID: make a bus from hid code
 # bad:  [990436a7] HID: move ids into separate file
 # bad:  [c500c971] HID: hid, make parsing event driven

So the bad commit seems to be:

commit c500c9714011edab021591340042787722db9cf0
Author: Jiri Slaby <jirislaby@gmail.com>
Date:   Fri May 16 11:49:16 2008 +0200

    HID: hid, make parsing event driven

    Next step for complete hid bus, this patch includes:
    - call parser either from probe or from hid-core if there is no probe.
    - add ll_driver structure and centralize some stuff there (open, close...)
    - split and merge usb_hid_configure and hid_probe into several functions
      to allow hooks/fixes between them

    Signed-off-by: Jiri Slaby <jslaby@suse.cz>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Any ideas, gentlemen?

- Steven

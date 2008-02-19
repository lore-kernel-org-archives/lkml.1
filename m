Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbYBSSLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbYBSSLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751256AbYBSSLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:11:44 -0500
Received: from dbservice.com ([213.239.204.14]:56990 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751052AbYBSSLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:11:44 -0500
Message-ID: <47BB1BD3.3040609@dbservice.com>
Date: Tue, 19 Feb 2008 19:11:31 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20080211)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: hid device not claimed but /dev/input/event exists
References: <47BB041F.4060003@dbservice.com> <Pine.LNX.4.64.0802191751040.7699@twin.jikos.cz> <47BB1515.1070608@dbservice.com> <Pine.LNX.4.64.0802191846250.30955@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0802191846250.30955@jikos.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.257, required 5, AWL 0.24, BAYES_00 -2.60,
	RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Tue, 19 Feb 2008, Tomas Carnecky wrote:
> 
>> The device apparently has four 'interfaces' - whatever that is, see [1]. 
>> It seems like usbhid probes interface 2 (which is the LCD plus a few 
>> buttons, probably the four just under the LCD, as described [1]). 
>> Because usbhid doesn't know how to handle the buttons, it fails. But 
>> then it probes interface 3 which is a 'proper' HID device with 
>> well-defined buttons.
> 
> Yes, the dump clearly shows that.
> 
> Does anything appear in dmesg when you press those buttons? There should 
> be messages resembling the one you already have there:
> 
> drivers/hid/hid-core.c: report (size 8) (unnumbered)
> drivers/hid/hid-core.c: report 0 (size 8) =  00 00 28 00 00 00 00 00
> 
> and they should react to keys such as FastForward, Play, Mute, Volume Up, 
> etc.

Nothing. Not even after I removed the alsa-usb-audio driver. All I see 
is Keyboard.*, but the events from the speaker should be Key.*, right?

It looks like the speaker goes into a different mode once the USB cable 
is plugged in. Without the USB cable, the Z-10 acts as simple/dumb 
speaker, the volume up/down buttons change the internal volume, and I 
see that on the display, too. The play/next/prev song buttons don't do 
anything, which is quite obvious.
But once the USB cable is plugged in, the volume up/down buttons stop 
reacting. I assume they are now meant to send events to the computer so 
that some software can decide what to do. But features that are not 
useful for the computer (bass/treble), can still be controlled using the 
buttons on the speaker. The buttons are not dead. I can see that because 
the display goes to sleep after a few seconds of inactivity, and when I 
press the volume buttons, it wakes up and displays the current volume. 
So the speaker is definitely seeing that the buttons are being pressed.

Is there a USB packet inspector/dumper, like libpcap for network?

tom

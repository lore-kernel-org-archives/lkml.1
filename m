Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbXERGhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbXERGhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754466AbXERGhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:37:38 -0400
Received: from neopsis.com ([213.239.204.14]:42520 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752893AbXERGhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:37:38 -0400
Message-ID: <464D4F31.6000100@dbservice.com>
Date: Fri, 18 May 2007 09:01:05 +0200
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: SideWinder GameVoice driver
References: <464C5FAC.8060609@dbservice.com> <Pine.LNX.4.64.0705171623280.27422@twin.jikos.cz> <464C708C.6090808@dbservice.com> <464CA34F.8090509@dbservice.com> <Pine.LNX.4.64.0705172309240.27422@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0705172309240.27422@twin.jikos.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.368,
	required 5, autolearn=spam, AWL 0.23, BAYES_00 -2.60)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> We don't want neither the 'Telephony' nor 'LEDs' usages to be claimed by 
> the hid-input system, that seems to make a little sense. 

I changed the IS_INPUT_APPLICATION() macro to accept 'Telephony/Headset'
and now the kernel has created a new event device node for the device
and it correctly generates evdev events if I press the keys on the pad.
(The LEDs can't be controlled, they light up if a key is pressed, they
are 'passive' from the POV of the kernel). So right now, I couldn't be
happier with how it works :)

> 
> So either the device is bogus and has broken report descriptor (which we 
> could fix in runtime), or it really can't be handled by hid-input (I have 
> no idea about the purpose and internal working of the device in question, 
> sorry).

GameVoice is used for VoIP communication between players. It consists of
a software and the small pad with eight buttons and connectors for the
headset. One of the buttons can be used to mute the microphone, the
others are labeled '1' - '4', 'TEAM', 'ALL' and 'COMMAND'. The idea is
that you can have up to four 'groups' of players and communicate only to
 certain groups by 'activating' the buttons, you can also speak to your
whole team or all players. The command button is used for voice commands
(for example, you press the button, say 'throw grenade' and the software
translates it to a predefined key sequence). That's more or less how
it's supposed to work.

Google gives you lots of images if you search for 'gamevoice':
http://pcdreitz.wintotal-forum.de/pys/gamevoice.jpg

> 
> Either we can fix the hiddev_connect() so that the device would be claimed 
> by hiddev (*) and you can write the driver for this device easily in 
> userland, or you could try to write generic in-kernel hid-telephony.c 
> handler of all telephony devices (but I doubt this is doable in a 
> reasonable way).

I'd much rather have this handled by hid-input, there's no reason to
have an additional driver (neither in the kernel nor in userland). It
'just works' with hid-input.

tom

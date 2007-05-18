Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbXERVUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbXERVUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:20:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXERVT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:19:58 -0400
Received: from twin.jikos.cz ([213.151.79.26]:33638 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbXERVT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:19:58 -0400
Date: Fri, 18 May 2007 23:19:53 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Tomas Carnecky <tom@dbservice.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: SideWinder GameVoice driver
In-Reply-To: <464D4F31.6000100@dbservice.com>
Message-ID: <Pine.LNX.4.64.0705182304400.27422@twin.jikos.cz>
References: <464C5FAC.8060609@dbservice.com> <Pine.LNX.4.64.0705171623280.27422@twin.jikos.cz>
 <464C708C.6090808@dbservice.com> <464CA34F.8090509@dbservice.com>
 <Pine.LNX.4.64.0705172309240.27422@twin.jikos.cz> <464D4F31.6000100@dbservice.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007, Tomas Carnecky wrote:

> > We don't want neither the 'Telephony' nor 'LEDs' usages to be claimed 
> > by the hid-input system, that seems to make a little sense.
> I changed the IS_INPUT_APPLICATION() macro to accept 'Telephony/Headset' 
> and now the kernel has created a new event device node for the device 
> and it correctly generates evdev events if I press the keys on the pad. 
> (The LEDs can't be controlled, they light up if a key is pressed, they 
> are 'passive' from the POV of the kernel). So right now, I couldn't be 
> happier with how it works :)

Hi Tomas,

unfortunately, I can hardly accept such a patch to go into mainline, 
sorry. If the device has only Telephony/Headset application and no other 
input-compatible usage, we just can't blindly pass it exclusively to 
hid-input subsystem.

> GameVoice is used for VoIP communication between players. It consists of 
> a software and the small pad with eight buttons and connectors for the 
> headset. One of the buttons can be used to mute the microphone, the 
> others are labeled '1' - '4', 'TEAM', 'ALL' and 'COMMAND'. The idea is 
> that you can have up to four 'groups' of players and communicate only to
>  certain groups by 'activating' the buttons, you can also speak to your
> whole team or all players. The command button is used for voice commands
> (for example, you press the button, say 'throw grenade' and the software
> translates it to a predefined key sequence). That's more or less how
> it's supposed to work.

But all this is handled actually by userspace applications, right? Or do 
you want this whole functionality to go into a specialized kernel driver? 
Or does this require some interaction/processing between hardware and the 
driver?

> I'd much rather have this handled by hid-input, there's no reason to 
> have an additional driver (neither in the kernel nor in userland). It 
> 'just works' with hid-input.

Well, if the only purpose of this device is to pass status of pressed 
buttons into userspace driver (which is the case, as far as I understand 
it), it's just broken that it has 05 0b (i.e. Telephony/Headset) in its 
report descriptor.

Either fixing the report descriptor on the fly or adding a special quirk 
to force hid-input to claim the device would be needed. Would you care to 
create such patch?

Or did I just get it wrong and the device has also other purposes that 
should be handled by the kernel driver, than just trivial mapping of a few 
buttons into corresponding input events?

Thanks,

-- 
Jiri Kosina

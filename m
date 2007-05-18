Return-Path: <linux-kernel-owner+w=401wt.eu-S1755951AbXERVoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951AbXERVoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 17:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754241AbXERVoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 17:44:39 -0400
Received: from neopsis.com ([213.239.204.14]:47036 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753742AbXERVoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 17:44:39 -0400
Message-ID: <464E23CA.8040400@dbservice.com>
Date: Sat, 19 May 2007 00:08:10 +0200
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Jiri Kosina <jikos@jikos.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: SideWinder GameVoice driver
References: <464C5FAC.8060609@dbservice.com> <Pine.LNX.4.64.0705171623280.27422@twin.jikos.cz> <464C708C.6090808@dbservice.com> <464CA34F.8090509@dbservice.com> <Pine.LNX.4.64.0705172309240.27422@twin.jikos.cz> <464D4F31.6000100@dbservice.com> <Pine.LNX.4.64.0705182304400.27422@twin.jikos.cz>
In-Reply-To: <Pine.LNX.4.64.0705182304400.27422@twin.jikos.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.369,
	required 5, autolearn=spam, AWL 0.23, BAYES_00 -2.60)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Fri, 18 May 2007, Tomas Carnecky wrote:
>> GameVoice is used for VoIP communication between players. It consists of 
>> a software and the small pad with eight buttons and connectors for the 
>> headset. One of the buttons can be used to mute the microphone, the 
>> others are labeled '1' - '4', 'TEAM', 'ALL' and 'COMMAND'. The idea is 
>> that you can have up to four 'groups' of players and communicate only to
>>  certain groups by 'activating' the buttons, you can also speak to your
>> whole team or all players. The command button is used for voice commands
>> (for example, you press the button, say 'throw grenade' and the software
>> translates it to a predefined key sequence). That's more or less how
>> it's supposed to work.
> 
> But all this is handled actually by userspace applications, right? Or do 
> you want this whole functionality to go into a specialized kernel driver? 
> Or does this require some interaction/processing between hardware and the 
> driver?

There's no further processing needed in the kernel. The userspace
application would receive these input events and act accordingly, like:
read data from the soundcard and send it to the VoIP server, or only
certain channels based on which buttons are currently pressed etc.

> Well, if the only purpose of this device is to pass status of pressed 
> buttons into userspace driver (which is the case, as far as I understand 
> it), it's just broken that it has 05 0b (i.e. Telephony/Headset) in its 
> report descriptor.
> 
> Either fixing the report descriptor on the fly or adding a special quirk 
> to force hid-input to claim the device would be needed. Would you care to 
> create such patch?

I already thought about this option (to whitelist this particular
vendor/device ID as an hid-input device), but I first wanted some
feedback on the whole situation. As for the patch, I have zero knowledge
of the hid subsystem.. but if you give me a go on this, I'll try to dig
into the code and make a patch :)

> Or did I just get it wrong and the device has also other purposes that 
> should be handled by the kernel driver, than just trivial mapping of a few 
> buttons into corresponding input events?

This pad has no other purposes than just having eight buttons. Mapping
these buttons into input events is all that is needed to make a useful
userspace application for it.

Considering how many users actually have this device and try to get it
working under Linux (probably only me), I wouldn't be mad if you
rejected a patch. I don't even know if I will ever write an userspace
application for it! But, I have this device lying around on my table and
in my old Windows days it was quite useful, so I'd like to share my
findings with others.

tom

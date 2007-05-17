Return-Path: <linux-kernel-owner+w=401wt.eu-S1760767AbXEQVcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760767AbXEQVcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755041AbXEQVb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:31:56 -0400
Received: from twin.jikos.cz ([213.151.79.26]:39191 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbXEQVb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:31:56 -0400
Date: Thu, 17 May 2007 23:31:53 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Tomas Carnecky <tom@dbservice.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: SideWinder GameVoice driver
In-Reply-To: <464CA34F.8090509@dbservice.com>
Message-ID: <Pine.LNX.4.64.0705172309240.27422@twin.jikos.cz>
References: <464C5FAC.8060609@dbservice.com> <Pine.LNX.4.64.0705171623280.27422@twin.jikos.cz>
 <464C708C.6090808@dbservice.com> <464CA34F.8090509@dbservice.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007, Tomas Carnecky wrote:

> Additional info: HID device has two collections (whatever those are, I
> have _no_ idea):

If you are interested what usages and collections are (and if you are 
going to write the support for this device, you probably are :) ), please 
see http://www.usb.org/developers/hidpage - namely
http://www.usb.org/developers/devclass_docs/HID1_11.pdf and possibly also 
http://www.usb.org/developers/devclass_docs/Hut1_12.pdf

> The culprit is the IS_INPUT_APPLICATION() macro, which only accepts 
> certain 'usage' types. Should it also accept this particular one, too, 
> or even the whole 'Telephony' group? Or maybe add a (configurable) 
> 'quirk' to enable the GameVoice device?

We don't want neither the 'Telephony' nor 'LEDs' usages to be claimed by 
the hid-input system, that seems to make a little sense. 

So either the device is bogus and has broken report descriptor (which we 
could fix in runtime), or it really can't be handled by hid-input (I have 
no idea about the purpose and internal working of the device in question, 
sorry).

Either we can fix the hiddev_connect() so that the device would be claimed 
by hiddev (*) and you can write the driver for this device easily in 
userland, or you could try to write generic in-kernel hid-telephony.c 
handler of all telephony devices (but I doubt this is doable in a 
reasonable way).

(*) I currently have no idea why this device is not claimed by hiddev 
though - it seems to have all collections of type 
HID_COLLECTION_APPLICATION which obviously are not IS_INPUT_APPLICATION() 
... could you please put debugging output into hiddev_connect() to examine 
why your device is not being claimed by hiddev?

Thanks,

-- 
Jiri Kosina

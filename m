Return-Path: <linux-kernel-owner+w=401wt.eu-S1752999AbXCUVk6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbXCUVk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 17:40:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbXCUVk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 17:40:58 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36610 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbXCUVk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 17:40:57 -0400
Date: Wed, 21 Mar 2007 22:40:36 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Kevin Baradon <kevin.baradon@gmail.com>
cc: linux-kernel@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
       bluez-devel@lists.sourceforge.net, Amedee Van Gasse <amedee@amedee.be>
Subject: Re: BUG: at drivers/hid/hid-core.c:778 implement() with bluetooth
 keyboard/mouse
In-Reply-To: <200703211923.04651.Kevin.Baradon@gmail.com>
Message-ID: <Pine.LNX.4.64.0703212231230.5030@twin.jikos.cz>
References: <200703211923.04651.Kevin.Baradon@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Kevin Baradon wrote:

> Hello everybody,
> [1.] One line summary of the problem :
> "BUG: at drivers/hid/hid-core.c:778 implement()" message in logs when booting 
> with bluetooth keyboard + mouse.
> [2.] Full description of the problem/report :
> During bootup, warnings (see below) are emitted in system log. 
> Hardware : 
> - P4 3.06MHz
> - Logitech Cordless MX Desktop for Bluetooth (keyboard + mouse with an USB 
> bluetooth adapter).

(relevant CCs added)

Hi Kevin,

there have been similar reports previously, all with recent Logitech 
dongles. See for example [1].

The bug is triggered by hid2hci when it tries to switch the Bluetooth 
dongle from HID to HCI mode. Most probably Logitech has changed the 
sequence that is needed to switch the dongle.

hid2hci has hardcoded reports that it uses to switch the dongle between 
HID and HCI modes. These reports are vendor-specific and are not described 
in report descriptor, therefore it's non-trivial to know what new pieces 
of hardware are expecting.

Marcel, did you by any chance have time to look at the dump that Amedee 
catched using usbsnoop some time ago? [2]

Thanks.

[1] http://lkml.org/lkml/2007/2/16/215
[2] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg128743.html

-- 
Jiri Kosina

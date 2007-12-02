Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbXLBSIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbXLBSIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXLBSID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:08:03 -0500
Received: from twin.jikos.cz ([213.151.79.26]:41700 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754852AbXLBSIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:08:01 -0500
Date: Sun, 2 Dec 2007 19:07:46 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Mark Lord <lkml@rtr.ca>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.24:  false double-clicks from USB mouse
In-Reply-To: <4752E432.10504@rtr.ca>
Message-ID: <Pine.LNX.4.64.0712021903460.12208@twin.jikos.cz>
References: <4752DB8C.50608@rtr.ca> <4752E432.10504@rtr.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Dec 2007, Mark Lord wrote:

> > Single-clicking on things with 2.6.24 very frequently gives a 
> > "double-click". This does not happen with 2.6.23.8. I wonder what 
> > broke it? I've grabbed mousedev.c from 2.6.23 and inserted that in 
> > place of the updated 2.6.24 source, but no change.  So it's not that 
> > file.
> Mmm.. reverting the entire drivers/hid directory to that from 2.6.23
> seems to have fixed the problem, so we now know it's in there somewhere.
> Jiri: do you have any suggestions that might be more specific than that ?

Could you please run evtest on the mouse device and send me what is 
reported when these false double-clicks happen? Also providing debug 
output of usbhid might or might not be helpful (*)

There were not that many changes in USB HID apart from adding per-device 
quirks for specific broken devices. Could you please try reverting 
c01d50d18, 933e3187, 82eb1219 to see if any of them makes this go away? 

(*) this means compiling with CONFIG_HID_DEBUG and modprobing hid module 
with 'debug=1'.

Thanks,

-- 
Jiri Kosina


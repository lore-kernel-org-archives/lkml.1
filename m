Return-Path: <linux-kernel-owner+w=401wt.eu-S1750742AbXBVKqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750742AbXBVKqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 05:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750757AbXBVKqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 05:46:54 -0500
Received: from twin.jikos.cz ([213.151.79.26]:55634 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750742AbXBVKqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 05:46:53 -0500
Date: Thu, 22 Feb 2007 11:46:34 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Veronique & Vincent <vinctre@videotron.ca>
cc: Pete Zaitcev <zaitcev@redhat.com>, marcel@holtmann.org,
       vincent.fortier1@ec.gc.ca, linux-kernel@vger.kernel.org
Subject: Re: Boot time Bluetooth BUG: warning: (value > m) at hid-core.c:793
In-Reply-To: <200702220538.39341.vinctre@videotron.ca>
Message-ID: <Pine.LNX.4.64.0702221139500.10496@twin.jikos.cz>
References: <200702192111.47017.vinctre@videotron.ca>
 <Pine.LNX.4.64.0702200854520.25686@twin.jikos.cz> <20070221185012.e4deeb68.zaitcev@redhat.com>
 <200702220538.39341.vinctre@videotron.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Feb 2007, Veronique & Vincent wrote:

> > > - report descriptor dump - seems to be missing in the output (it 
> > >   should read something like "hid-core.c: report descriptor (size 
> > >   XY, read YZ) = ... some hexadecimal numbers". This should be 
> > >   output by the time the HID device is connected.
> The full dmesg with define DEBUG was included in the original message.  Unless 
> something else was needed?

Unfortunately it was missing the report descriptor dump. The output should 
look like

drivers/usb/input/hid-core.c: report descriptor (size 59, read 59) = 05 01 
09 06 a1 01 05 07 19 e0 29 e7 15 00 25 01 75 01 95 08 81 02 81 03 95 05 05 
08 19 01 29 05 91 02 95 01 75 03 91 01 95 06 75 08 15 00 26 a4 00 05 07 19 
00 2a a4 00 81 00 c0

and it should appear as soon as you connect the device. If it didn't, I 
suspect that the 

	#define DEBUG_DATA

was not set properly in drivers/usb/input/hid-core.c (only defining DEBUG 
is not enough for report descriptor dump to appear).

> I was actually getting that on a stock FC6 kernel.  The dmesg output 
> comes from a recompiled vanilla 2.6.19.x with the exact same 
> configuration BUT the modified define's in hid-core.c and a local 
> version appended to the .config file.  So this BUG does not only affect 
> FC6 users but also the vanilla kernel.

But so far all reports that have gathered for this bug at me seem to come 
from FC6 ... does hid2hci by any chance in FC6 have any additional patches 
that could be causing it, instead of being a kernel issue?

Thanks,

-- 
Jiri Kosina

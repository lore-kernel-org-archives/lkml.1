Return-Path: <linux-kernel-owner+w=401wt.eu-S965356AbXDBKOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965356AbXDBKOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 06:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965369AbXDBKOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 06:14:10 -0400
Received: from server225-han.de-nserver.de ([85.158.176.91]:55917 "EHLO
	server225-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965356AbXDBKOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 06:14:08 -0400
Message-ID: <4610D771.4020806@codemercs.com>
Date: Mon, 02 Apr 2007 12:14:09 +0200
From: Robert Marquardt <marquardt@codemercs.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dtor@insightbb.com>, Li Yu <raise.sail@gmail.com>,
       yanghong@ccoss.com.cn,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>,
       hongzhiyi@ccoss.com.cn, Marcel Holtmann <marcel@holtmann.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [RFC] HID bus design overview.
References: <200703051532096508636@gmail.com> <200703300033.22059.dtor@insightbb.com> <Pine.LNX.4.64.0704010002280.6040@jikos.suse.cz> <200704020009.26345.dtor@insightbb.com> <Pine.LNX.4.64.0704021134250.3808@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0704021134250.3808@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by marquardt@codemercs.com through 87.187.41.158
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:

> I agree. I am aware of devices for which just inspecting the parsed data 
> would be OK (some keyboards with usage mappings which are not defined by 
> HUT, for example), but also of devices which require special handling on 
> the report level - Robert Marquardt pointed me in a private mail to a few 
> devices which are broken par-excellence, and for which handling on report 
> level would be convenient.
> 
> Also, handling on report level would be nice to have so that we could hook 
> a hidraw driver to it.

Just forgot to use "Reply All".

Here is the text (expanded):
Definitely. I know of several devices where the HID descriptor and the 
data sent completely disagree.
A Metex USB Multimeter for example tells that it has a 4 byte report 
divided into a 3 byte and a 1 byte element. The device sends two reports 
each containing two 2 byte elements with one in the second report not 
containing data.
The wierdest device is a CD archive torus which shows up as a simple 
standard mouse. Commands are sent by *reading* strings.
The Office Rocket Launcher is posing as a keyboard and reacts to the 
LEDs being set (this is of interest for the Num-Lock thread here).
I definitely hope that the latter two devices will never get official 
kernel support in any way.

Why is the report parsed on driver level at all? It should be possible 
to allow drivers to manipulate the reports, but i see no reason to split 
the report into usages that early. The Windows HID API parses the report 
happily in the HID.DLL for user programs. Drivers have the same API 
available on kernel level.
So a raw API for the drivers should be the primary API. It is usually 
easier to manipulate the report directly instead of abstract operations. 
It is also fairly safe. The device has been identified so the offending 
report layout can be presumed. Parsing for specific usages should be 
done from the driver. Preparsing the report before the data is handed to 
the driver only wastes CPU cycles.

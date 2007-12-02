Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbXLBStA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbXLBStA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 13:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbXLBSsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 13:48:52 -0500
Received: from rtr.ca ([76.10.145.34]:2170 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbXLBSsv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 13:48:51 -0500
Message-ID: <4752FE11.2050200@rtr.ca>
Date: Sun, 02 Dec 2007 13:48:49 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.24:  false double-clicks from USB mouse
References: <4752DB8C.50608@rtr.ca> <4752E432.10504@rtr.ca> <Pine.LNX.4.64.0712021903460.12208@twin.jikos.cz> <4752F6C7.4040904@rtr.ca> <Pine.LNX.4.64.0712021918500.13260@jikos.suse.cz>
In-Reply-To: <Pine.LNX.4.64.0712021918500.13260@jikos.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
...
> First it would be really helpful to see if
> 
> - the HID driver really obtains two click events from USB stack. This 
>   could be easily seen from HID debug output. I have written in previous 
>   mail how to obtain this
..

That's in the queue..  :)


> - the output of evtest for the mouse device in /dev/input/event? (for 
>   determinign the correcnt event number corresponding to your mouse, see 
>   /proc/bus/input/devices)
..

Here's a *single* button click (press/release quickly):

Event: time 1196621063.612542, type 1 (Key), code 272 (LeftBtn), value 1
Event: time 1196621063.612553, type 0 (Reset), code 0 (Reset), value 0
Event: time 1196621063.620504, type 1 (Key), code 272 (LeftBtn), value 0
Event: time 1196621063.620512, type 0 (Reset), code 0 (Reset), value 0
Event: time 1196621063.628497, type 1 (Key), code 272 (LeftBtn), value 1
Event: time 1196621063.628502, type 0 (Reset), code 0 (Reset), value 0
Event: time 1196621063.684524, type 1 (Key), code 272 (LeftBtn), value 0
Event: time 1196621063.684531, type 0 (Reset), code 0 (Reset), value 0
Event: time 1196621063.700532, type 1 (Key), code 272 (LeftBtn), value 1
Event: time 1196621063.700538, type 0 (Reset), code 0 (Reset), value 0
Event: time 1196621063.764540, type 1 (Key), code 272 (LeftBtn), value 0
Event: time 1196621063.764550, type 0 (Reset), code 0 (Reset), value 0

Here's another one, except I held the button firmly down for a second or so,
and then released it:

Event: time 1196621197.179635, type 1 (Key), code 272 (LeftBtn), value 1
Event: time 1196621197.179645, type 0 (Reset), code 0 (Reset), value 0
Event: time 1196621198.323607, type 1 (Key), code 272 (LeftBtn), value 0
Event: time 1196621198.323616, type 0 (Reset), code 0 (Reset), value 0

I'll go work on the CONFIG_HID_DEBUG thing next.



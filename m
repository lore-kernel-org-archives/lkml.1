Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbXHZGIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbXHZGIl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 02:08:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbXHZGId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 02:08:33 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35371
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751258AbXHZGIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 02:08:32 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: What's up with CONFIG_BLK_DEV?
Date: Sun, 26 Aug 2007 01:08:28 -0500
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200708241517.28475.rob@landley.net> <Pine.LNX.4.64.0708242234250.28540@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0708242234500.28540@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0708242234500.28540@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708260108.28584.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2007 3:36:54 pm Jan Engelhardt wrote:
> On Aug 24 2007 22:34, Jan Engelhardt wrote:
> >On Aug 24 2007 15:17, Rob Landley wrote:
> >>CONFIG_BLOCK disables the block layer.
> >>CONFIG_BLK_DEV disables the block devices.
> >
> >menuconfig BLK_DEV
> >        bool "Block devices"
> >        depends on BLOCK
> >        default y
> >        ---help---
> >          Say Y here to get to see options for various different block
> > device drivers. This option alone does not add any kernel code.
> >
> >          If you say N, all options in this submenu will be skipped and
> > disabled only do this if you know what you are doing.
> >
> >>Is there _ever_ a time you want the block layer but no block devices?
>
> Well, where do you think your hard disk drivers come from? Definitely
> not from the BLK_DEV menu...

Actually I hadn't looked that far into it.  Juggling seven things yesterday 
and offline most of today, and what I actually _noticed_ was that my 
miniconfig that had worked unchanged to build UML since 2.6.12 finally broke 
on a kernel upgrade, and I have no idea what the actual reason for the change 
is other than possibly aesthetics.  Oh well.

Now that I look I see that all the devices in this menu (at least in User Mode 
Linux) are actually virtual block devices (UBD, loopback, and ramdisk), which 
the menu help doesn't indicate.

Now I'm trying to think of a better user interface way of cross-referencing 
this sort of thing.  Network block devices live in the networking menu, 
device drivers for hardware live off in another menu.  What I really want is 
a way to dynamically create menus via search critiera: "Show me all the block 
devices"...

Also "here's a symbol, show me a menu containing everything else that is 
either required by or enabled by this symbol..."  That sounds like a more 
powerful abstraction, since the previous one is "show me everything that 
depends on CONFIG_BLOCK".

(I wonder if this would be a largeish rewrite of the menuconfig 
infrastructure?  Hmmm...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

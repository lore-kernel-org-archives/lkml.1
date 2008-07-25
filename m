Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbYGYWBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbYGYWBK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 18:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYGYWA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 18:00:57 -0400
Received: from cnc.isely.net ([64.81.146.143]:45650 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYGYWA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 18:00:57 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2008 18:00:57 EDT
Date: Fri, 25 Jul 2008 16:55:47 -0500 (CDT)
From: Mike Isely <isely@pobox.com>
X-X-Sender: isely@cnc.isely.net
To: Trever Fischer <wm161@wm161.net>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cypress_m8 driver is broken with my GPS device
In-Reply-To: <200807251700.56399.wm161@wm161.net>
Message-ID: <Pine.LNX.4.64.0807251649500.28819@cnc.isely.net>
References: <200807251700.56399.wm161@wm161.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2008, Trever Fischer wrote:

> Hi, I've got a DeLORME Earthmate LT-20 USB GPS unit. A year or so ago it used 
> to work with the cypress_m8 driver, but now when I try to read from the 
> device, the kernel spits out:
> 
> drivers/usb/serial/cypress_m8.c: cypress_serial_control - failed to retrieve 
> serial line settings - -32
> drivers/usb/serial/cypress_m8.c: cypress_m8 suspending failing port 3 - 
> interval might be too short
> 
> I dug into the source and created the attached patch. Its my first (albeit 
> tiny) patch to the linux kernel, so any feedback is graciously welcome.
> 

Nacked-By: Mike Isely <isely@pobox.com>

Trever:

Which kernel did you debug this against?  I ask, because I encountered 
and fixed this exact problem months ago.  The fix(es) (there were 
several) first appeared in the 2.6.26 kernel tree.  Look at cypress_m8.c 
there and search for get_cfg_unsafe.  It's a new flag I added to mark if 
the device can be safely queried for configuration.  The flag is set 
appropriately depending on the specific variant Earthmate device in use.

Please try the later kernel and tell me if the problem is still 
happening.

  -Mike


-- 

Mike Isely
isely @ pobox (dot) com
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8

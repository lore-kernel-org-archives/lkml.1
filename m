Return-Path: <linux-kernel-owner+w=401wt.eu-S1763837AbYALOz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763837AbYALOz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 09:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762848AbYALOzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 09:55:18 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46608 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762815AbYALOzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 09:55:17 -0500
Date: Sat, 12 Jan 2008 14:54:49 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Lucas Woods <woodzy@gmail.com>, Andre Haupt <andre@bitwigglers.org>,
       Michael-Luke Jones <jonesml@fastmail.to>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Fwd: Issue with arm-devel tree
Message-ID: <20080112145449.GA11341@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It might be a good idea if there was some co-ordination with people
involved in the duplicate include removal work...

    [ARM] remove duplicate includes
    
    Signed-off-by: Lucas Woods <woodzy@gmail.com>
    Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

@@ -20,7 +20,6 @@
 #include <linux/module.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <linux/reboot.h>
 
 #include <asm/mach-types.h>


    [ARM] ixp4xx: remove double include
    
     Remove double include.
    
    Signed-off-by: Andre Haupt <andre@bitwigglers.org>
    Signed-off-by: Alessandro Zummo <a.zummo@towertech.it>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>

@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/reboot.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
 #include <linux/reboot.h>

I've dropped the "ixp4xx: remove double include" commit and fixed the
resulting breakage of "remove duplicate includes" change to resolve this
problem.

----- Forwarded message from Michael-Luke Jones <jonesml@fastmail.to> -----

To: rmk@arm.linux.org.uk
From: Michael-Luke Jones <jonesml@fastmail.to>
Subject: Issue with arm-devel tree
Date: Sat, 12 Jan 2008 14:23:44 +0000

http://ftp.arm.linux.org.uk/pub/linux/arm/kernel/git-cur/arm:devel.mbox

contains two patches:

"Re: [ARM] remove duplicate includes" from Lucas Woods  
<woodzy@gmail.com>
"Re: [ARM] ixp4xx: remove double include" from Andre Haupt  
<andre@bitwigglers.org>

which between the two of them manage to delete *both* instances of  
#include <linux/reboot.h> in nslu2-power.c

Given that nslu2-power.c calls machine_power_off() and ctrl_alt_del()  
this probably isn't a good thing.

Michael-Luke Jones

----- End forwarded message -----

-- 
Russell King

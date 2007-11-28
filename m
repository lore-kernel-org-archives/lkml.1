Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbXK1UHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbXK1UHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbXK1UGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:06:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37933 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754167AbXK1UGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:06:53 -0500
Date: Wed, 28 Nov 2007 12:06:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm2 (build failure on arm)
Message-Id: <20071128120649.019e3689.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0711281152220.12651@schroedinger.engr.sgi.com>
References: <20071128034140.648383f0.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0711281152220.12651@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 11:54:10 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:

> Crossbuild on arm with shark_deconfig fails:
> 
>   CC [M]  sound/oss/uart401.o
>   CC      net/sched/sch_generic.o
>   CC      net/core/dst.o
>   AS      arch/arm/lib/getuser.o
> drivers/ide/arm/ide_arm.c: In function 'ide_arm_init':
> drivers/ide/arm/ide_arm.c:42: error: implicit declaration of function 
> 'ide_device_idx'
> make[2]: *** [drivers/ide/arm/ide_arm.o] Error 1
> make[1]: *** [drivers/ide] Error 2
> make[1]: *** Waiting for unfinished jobs....
>   CC      net/core/netevent.o
>   CC      net/core/neighbour.o
> 

this, I guess:

--- a/drivers/ide/arm/ide_arm.c~fix-ide-mm-ide-fix-host-drivers-depending-on-ide_generic-to-probe-for-interfaces
+++ a/drivers/ide/arm/ide_arm.c
@@ -39,6 +39,6 @@ void __init ide_arm_init(void)
 		ide_init_port_hw(hwif, &hw);
 		idx[0] = hwif->index;
 
-		ide_device_idx(idx);
+		ide_device_add(idx);
 	}
 }
_


Return-Path: <linux-kernel-owner+w=401wt.eu-S970764AbXEHX5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970764AbXEHX5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:57:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970379AbXEHX52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:57:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46504 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968143AbXEHX51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:57:27 -0400
Date: Tue, 8 May 2007 16:57:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Kevin Winchester <kjwinchester@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot
In-Reply-To: <464108CC.3060604@gmail.com>
Message-ID: <Pine.LNX.4.64.0705081655560.16476@schroedinger.engr.sgi.com>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
 <4640FE35.2070605@gmail.com> <Pine.LNX.4.64.0705081557560.15790@schroedinger.engr.sgi.com>
 <464108CC.3060604@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Kevin Winchester wrote:

> [    1.376783]  [<ffffffff8067d664>] kernel_init+0xc4/0x2a0
> [    1.376857]  [<ffffffff802080aa>] __switch_to+0x2a/0x2d0
> [    1.376932]  [<ffffffff8020a5d8>] child_rip+0xa/0x12
> [    1.377006]  [<ffffffff8067d5a0>] kernel_init+0x0/0x2a0
> [    1.377080]  [<ffffffff8020a5ce>] child_rip+0x0/0x12
> [    1.377151]
> [    1.377221] @@@ SLUB kmalloc-256: Restoring Poison (0x6b) from
> 0xffff810001bdecd0-0xffff810001bdedce
> [    1.377326] @@@ SLUB kmalloc-256: Restoring Poison (0xa5) from
> 0xffff810001bdedcf-0xffff810001bdedcf
> [    1.377430] @@@ SLUB: kmalloc-256 slab 0xffff810001061890. Marking all
> objects used.


There is more... The above describes the repair actions that were taken by 
SLUB. Poison was restored and then the slab was taken out of circulation 
since pointers may still exist that may damage additional objects if used 
to store more data.



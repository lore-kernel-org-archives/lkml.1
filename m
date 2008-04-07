Return-Path: <linux-kernel-owner+w=401wt.eu-S1757462AbYDGXeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbYDGXeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 19:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYDGXeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 19:34:07 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:52094 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYDGXeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 19:34:06 -0400
Subject: fully bisectable real time series
From: Daniel Walker <dwalker@mvista.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       mingo@elte.hu
Content-Type: text/plain
Date: Mon, 07 Apr 2008 16:34:02 -0700
Message-Id: <1207611243.21308.167.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've re-worked the -rt series, and some of the core patches to make it
all bisectable. I've done bisect updates in the past which really only
scratched the surface.

The main problems where around the spinlock, semaphore, and rw-semaphore
changes. I made a number of updates to how the bottom level spinlocks
get defined to ease the transition per-patch and architecture. For
semaphores I removed some constraints on how many changes need to be
made per architecture.

So what's missing? Well I dropped every architecture port except x86,
since I broke them all. I also dropped a number of non-essential patches
(mostly from Peter) not for any technical reason but just to reduce the
amount of code. 

I didn't fix all the architectures since I want to make sure x86 is
solid before I start moving the other architectures to the new format.
All the dropped patches are still part of the archive, just not in the
series.

x86 32-bit is compile and boot bisectable, and 64-bit is compile
bisectable (should boot too, but I haven't tested it.)

There's tons of back merging to do, but I keep it to a minimum for the
time being. I'm sure there are some un-bisectable areas that I just
haven't found yet, however if you report it to me I'll be happy to fix
them.

I'm only providing a broken out series and you can download in from,

ftp://source.mvista.com/pub/dwalker/rt/patch-2.6.24.4-rt4-dw1-broken-out.tar.bz2

Enjoy!

Daniel


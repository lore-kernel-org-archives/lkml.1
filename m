Return-Path: <linux-kernel-owner+w=401wt.eu-S970513AbXEHXnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970513AbXEHXnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969798AbXEHXnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:43:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37846 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S968116AbXEHXnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:43:07 -0400
Date: Tue, 8 May 2007 16:43:05 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Kevin Winchester <kjwinchester@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1 and now 2.6.21-git: SLUB Crashes on boot
In-Reply-To: <464108CC.3060604@gmail.com>
Message-ID: <Pine.LNX.4.64.0705081639570.16372@schroedinger.engr.sgi.com>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
 <4640FE35.2070605@gmail.com> <Pine.LNX.4.64.0705081557560.15790@schroedinger.engr.sgi.com>
 <464108CC.3060604@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1700579579-1558832318-1178667785=:16372"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1700579579-1558832318-1178667785=:16372
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Tue, 8 May 2007, Kevin Winchester wrote:

> Here's the dmesg of the slub_debug run, I'll try the patch next:

Ok someone wrote to an object after it was freed. Not slubs problem.

> [    1.367129]     Object 0xffff810001bdecd0:  80 b7 b1 01 00 81 ff ff 6b=
 6b
> 6b 6b 6b 6b 6b 6b .=B7=B1...kkkkkkkk

The first 8 bytes of the freed object were overwritten.

> [    1.374455] Last alloc: cryptomgr_notify+0x28/0x190 jiffies_ago=3D0 cp=
u=3D0
> pid=3D1
> [    1.374611] Last free : cryptomgr_probe+0x85/0xb0 jiffies_ago=3D0 cpu=
=3D0
> pid=3D405

Here are some potential candidates that have recently handled the object.=
=20
That was less than a jiffy ago. So very recent.


---1700579579-1558832318-1178667785=:16372--

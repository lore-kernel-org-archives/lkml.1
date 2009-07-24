Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbZGXVwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbZGXVwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 17:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZGXVwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 17:52:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56942 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751589AbZGXVv7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 17:51:59 -0400
Date: Fri, 24 Jul 2009 14:50:25 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: =?UTF-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Arnd Bergmann <arnd@arndb.de>, virtualization@lists.linux-foundation.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, virtualization@lists.osdl.org,
       Sam Ramji <sramji@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [patch 34/54] Staging: hv: remove STRUCT_PACKED and
 STRUCT_ALIGNED defines
Message-ID: <20090724145025.12da5a6e@nehalam>
In-Reply-To: <20090724213218.GA13702@logfs.org>
References: <20090717180850.873962925@mini.kroah.org>
	<20090717180921.448023599@mini.kroah.org>
	<200907210146.41399.arnd@arndb.de>
	<20090724213218.GA13702@logfs.org>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 23:32:19 +0200
Jörn Engel <joern@logfs.org> wrote:

> On Tue, 21 July 2009 01:46:41 +0200, Arnd Bergmann wrote:
> > On Friday 17 July 2009, Greg Kroah-Hartman wrote:
> > > @@ -43,7 +43,7 @@ typedef struct _RING_BUFFER {
> > >         // volatile u32 InterruptMask;
> > >         // Ring data starts here + RingDataStartOffset !!! DO NOT place any fields below this !!!
> > >      u8         Buffer[0];
> > > -} STRUCT_PACKED RING_BUFFER;
> > > +} __attribute__((packed)) RING_BUFFER;
> > >  
> > 
> > The data structure is actually packed already, the attribute does not make it better
> > and could be removed. We also have __packed as a shortcut for __attribute__((packed)).
> 
> Honestly, I don't know how useful __packed really is.  In a shared
> kernel/userspace header, it is only defined for the kernel.
> 

As I remember, gcc generates worse code for packed structures on many architectures
since it may have to do byte fetchs/recombining to avoid unaligned
accesses.

-- 

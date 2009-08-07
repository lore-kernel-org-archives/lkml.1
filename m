Return-Path: <linux-kernel-owner+w=401wt.eu-S1750905AbZHGEAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905AbZHGEAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 00:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750750AbZHGEAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 00:00:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705AbZHGEAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 00:00:47 -0400
Date: Thu, 6 Aug 2009 21:00:02 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Fischer, Anna" <anna.fischer@hp.com>
Cc: "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "evb@yahoogroups.com" <evb@yahoogroups.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "kaber@trash.net" <kaber@trash.net>,
       "adobriyan@gmail.com" <adobriyan@gmail.com>,
       Arnd Bergmann <arnd@arndb.de>,
       "Paul Congdon (UC Davis)" <ptcongdon@ucdavis.edu>
Subject: Re: [PATCH][RFC] net/bridge: add basic VEPA support
Message-ID: <20090806210002.75beb7c6@nehalam>
In-Reply-To: <0199E0D51A61344794750DC57738F58E67D2DCECBB@GVW1118EXC.americas.hpqcorp.net>
References: <0199E0D51A61344794750DC57738F58E67D2DCECBB@GVW1118EXC.americas.hpqcorp.net>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 17:33:10 +0000
"Fischer, Anna" <anna.fischer@hp.com> wrote:

> This patch adds basic Virtual Ethernet Port Aggregator (VEPA)
> capabilities to the Linux kernel Ethernet bridging code.
> 
> A Virtual Ethernet Port Aggregator (VEPA) is a capability within
> a physical end station that collaborates with an adjacent, external
> bridge to provide distributed bridging support between multiple
> virtual end stations and external networks. The VEPA collaborates
> by forwarding all station-originated frames to the adjacent bridge
> for frame processing and frame relay (including so-called 'hairpin'
> forwarding) and by steering and replicating frames received from
> the VEPA uplink to the appropriate destinations. A VEPA may be
> implemented in software or in conjunction with embedded hardware.
> 
> In particular, the patch extends the Linux Ethernet bridge to act as
> (1) a VEPA - for this we have added VEPA forwarding functionality and
>     added a configuration option for a VEPA uplink port, or as
> (2) a bridge supporting 'hairpin' forwarding - for this we have added a
>     bridge port 'hairpin' mode which allows sending frames back out
>     through the port the frame was received on.
> 
> Configuration of VEPA capabilities through Linux userspace bridge
> utilities is provided by an additional patch 'bridge-utils: add
> basic VEPA support'.

After reading more about this, I am not convinced this should be part
of the bridge code. The bridge code really consists of two parts:
forwarding table and optional spanning tree. Well the VEPA code
short circuits both of these; it can't imagine it working
with STP turned on. The only part of bridge code that really gets
used by this are the receive packet hooks and the crufty old
API.

So instead of adding more stuff to existing bridge code, why not
have a new driver for just VEPA. You could
do it with a simple version of macvlan type driver.

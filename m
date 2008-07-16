Return-Path: <linux-kernel-owner+w=401wt.eu-S1759805AbYGPWFk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759805AbYGPWFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:05:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758001AbYGPWFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:05:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757946AbYGPWFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:05:12 -0400
Date: Wed, 16 Jul 2008 17:57:45 -0400
From: Dave Jones <davej@redhat.com>
To: Scott Wood <scottwood@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/ep8248e: Fix compile problem if !CONFIG_FS_ENET
Message-ID: <20080716215745.GA17093@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Scott Wood <scottwood@freescale.com>,
	Kumar Gala <galak@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
	akpm@linux-foundation.org, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0807160838520.14127@blarg.am.freescale.net> <20080716214722.GA6251@ld0162-tx32.am.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716214722.GA6251@ld0162-tx32.am.freescale.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 04:47:23PM -0500, Scott Wood wrote:
 > On Wed, Jul 16, 2008 at 08:39:12AM -0500, Kumar Gala wrote:
 > > If we don't enable FS_ENET we get build issues:
 > > 
 > > arch/powerpc/platforms/built-in.o: In function `ep8248e_mdio_probe':
 > > arch/powerpc/platforms/82xx/ep8248e.c:129: undefined reference to `alloc_mdio_bitbang'
 > > arch/powerpc/platforms/82xx/ep8248e.c:143: undefined reference to `mdiobus_register'
 > 
 > How is this possible?  CONFIG_EP8248E selects CONFIG_MDIO_BITBANG.

If CONFIG_PHYLIB=m however, that doesn't make any difference, because
vmlinuz is trying to use a symbol which now lives in a module.

	Dave

-- 
http://www.codemonkey.org.uk

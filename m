Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZGRXUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZGRXUH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 19:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbZGRXUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 19:20:03 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43271 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966AbZGRXUC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 19:20:02 -0400
Date: Sat, 18 Jul 2009 18:20:00 -0500
From: Robin Holt <holt@sgi.com>
To: Julia Lawall <julia@diku.dk>
Cc: holt@sgi.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/6] drivers/misc/sgi-xp: convert nested
	spin_lock_irqsave to spin_lock
Message-ID: <20090718232000.GB7426@sgi.com>
References: <Pine.LNX.4.64.0907181723360.26792@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907181723360.26792@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 05:23:57PM +0200, Julia Lawall wrote:
> -			spin_lock_irqsave(&part_uv->flags_lock, irq_flags);
> +			spin_lock(&part_uv->flags_lock);
>  			part_uv->flags &= ~XPC_P_CACHED_ACTIVATE_GRU_MQ_DESC_UV;

Please do not change this.

I think this is a false positive to a automated script.  We are not
comparing against the processors irq flags, but rather against the
partitions flags.  Note above the difference between irq_flags and
part_uv->flags.

Maybe I misunderstand your point in this patch.

Robin

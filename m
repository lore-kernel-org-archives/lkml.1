Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbXLTGa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbXLTGa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 01:30:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXLTGaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 01:30:18 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:60049 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbXLTGaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 01:30:17 -0500
Message-ID: <fa686aa40712192230p206cc716rd85e21cb8d2bdde4@mail.gmail.com>
Date: Wed, 19 Dec 2007 23:30:16 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       sr@denx.de, monstr@monstr.eu, jwilliams@itee.uq.edu.au,
       stephen.neuendorffer@xilinx.com
Subject: Re: [PATCH] [RFC] Xilinx SystemACE: Add media hotplug support
In-Reply-To: <20071220062348.16448.24575.stgit@trillian.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071220062348.16448.24575.stgit@trillian.secretlab.ca>
X-Google-Sender-Auth: 0c9dbe03c9af2798
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/07, Grant Likely <grant.likely@secretlab.ca> wrote:
> From: Grant Likely <grant.likely@secretlab.ca>
>
> Please review and comment.  This patch works in my setup, but I haven't
> tested exhaustively yet.  I also need to fixup the documentation to
> reflect new states before I request this patch to be merged.
>
> Question for the block layer experts:  I'm using add_disk()/del_gendisk()
> functions to inform the kernel of media insertion and removal events.  Is
> this the best way to do this?  I looked at the .media_changed and
> .revalidate_disk hooks, but it doesn't seem like they offer the driver
> any way to notify the kernel of media removal (as opposed to the kernel
> asking the driver)

Heh, actually I *know* I'm doing the wrong thing; but I'm hoping I've
got better chances of getting steered in the right direction if I
start by throwing code out there.  Currently this patch handles
insertion/removal just fine if nothing is mounted, but gets stuck if
the disk is in use.  How do I get the kernel to cancel all pending
requests when deregistering the device?

Thanks,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
grant.likely@secretlab.ca
(403) 399-0195

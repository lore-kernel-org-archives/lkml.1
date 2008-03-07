Return-Path: <linux-kernel-owner+w=401wt.eu-S1764799AbYCGJVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764799AbYCGJVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 04:21:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762954AbYCGJN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 04:13:26 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:21582 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762525AbYCGJNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 04:13:23 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <200803071013.837692778@firstfloor.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/7] Block layer rework for mask allocator
Date: Fri,  7 Mar 2008 10:13:20 +0100 (CET)
X-OriginalArrivalTime: 07 Mar 2008 09:06:50.0721 (UTC) FILETIME=[9470F510:01C88032]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This reworks the block layer bouncing to use the mask allocator

Instead of using GFP_DMA use device masks derived from the bounce gfp
and pass it to the mask allocator. On architectures not converted
to the mask allocator the code will transparently fall back to GFP_DMA.

Requires the earlier mask allocator patchkit I posted.

It is still not 100% finished -- in particular the bouncer still
does not know how to use masks > ISA mask, but that is not very difficult
to add now. I first wanted to laid the groundwork.

One patch ("Convert the blk allocator functions over to the mask allocator")
depends on the "blk allocator" in the earlier SCSI DMA rework 
patchkit I've been posting. That patch can be dropped without trouble 
if that one is not applied, but if it is applied it is needed.

-Andi

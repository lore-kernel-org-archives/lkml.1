Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbYH2CVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbYH2CVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 22:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752582AbYH2CVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 22:21:22 -0400
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1461 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbYH2CVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 22:21:21 -0400
Date: Fri, 29 Aug 2008 04:21:18 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Eric Sesterhenn <snakebyte@gmx.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch] Fix another bug in hfsplus when reading a corrupted
 image
In-Reply-To: <20080826125909.GA21266@alice>
Message-ID: <Pine.LNX.4.64.0808290409220.2507@localhost.localdomain>
References: <20080826125909.GA21266@alice>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 26 Aug 2008, Eric Sesterhenn wrote:

> Problem is that there is no ext_tree, causing the NULL-pointer
> dereference in hfsplus_init(). This fixes the issue by checking the ext_tree in
> hfsplus_get_block() and aborting early enoug.

The problem is worse, a corrupted extent for the extent file itself may 
try to get an impossible extent, causing a deadlock if I see it correctly.
A better fix would be to check the inode number after the first_blocks 
checks and fail if it's the extent file, as according to the spec the 
extent file should have no extent for itself.

bye, Roman

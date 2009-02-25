Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZBYGzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZBYGzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 01:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZBYGyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 01:54:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54324 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbZBYGyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 01:54:54 -0500
Subject: Re: [PATCH 00/15] bitops: Change bitmap index from int to unsigned
 long
From: Peter Zijlstra <peterz@infradead.org>
To: Justin Chen <jchen@hpdst41.cup.hp.com>
Cc: linux-arch@vger.kernel.org, bjorn.helgaas@hp.com, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <200902250441.UAA12527@hpdst41.cup.hp.com>
References: <200902250441.UAA12527@hpdst41.cup.hp.com>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 07:54:48 +0100
Message-Id: <1235544888.4645.2942.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 20:41 -0800, Justin Chen wrote:
> his patch is to change the bitmap index in the bitops from "int" to
> "unsigned long".
> 
> In many bitops implementations, the bitmap index is a signed int.  If
> the caller passes a large unsigned integer and we interpret it as
> being negative, we compute an address outside the bitmap.  This can
> cause memory corruption or other errors.
> 
> The issue that triggered me to do this change is the routine
> mark_bootmem_node() while we ran on an ia64 box with large memory.  As
> long as the EFI maps the available memory chunk at the physical
> address 0x200000000000 (or above), the routine mark_bootmem_node()
> will get the start PFN>=0x80000000.  While it calls the __free() with
> this sidx=0x80000000 (bit31 set), the bitops (test_and_clear_bit) will
> treat this idx as a negative number since it accepts it as an "int".
> It turns out the memory outside the bitmap will be corrupted.
> 
> Following 15 patches will change all the bitmap index "nr" in all
> bitops from "int" to "unsigned long".
> 
> The patch is based on 2.6.29-rc6
> 
> Please comment -

unsigned int wasn't large enough?


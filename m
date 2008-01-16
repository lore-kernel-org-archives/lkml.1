Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbYAPBGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbYAPBGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYAPBGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:06:07 -0500
Received: from il.qumranet.com ([82.166.9.18]:36064 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYAPBGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:06:05 -0500
Date: Wed, 16 Jan 2008 02:06:01 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       daniel.blueman@quadrics.com, holt@sgi.com, steiner@sgi.com,
       Andrew Morton <akpm@osdl.org>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] mmu notifiers #v2
Message-ID: <20080116010601.GF7059@v2.random>
References: <20080113162418.GE8736@v2.random> <Pine.LNX.4.64.0801141154240.8300@schroedinger.engr.sgi.com> <20080115124449.GK30812@v2.random> <1200428333.6755.0.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200428333.6755.0.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 07:18:53AM +1100, Benjamin Herrenschmidt wrote:
> Do you have cases where it's -not- called with the PTE lock held ?

For invalidate_page no because currently it's only called next to the
ptep_get_and_clear that modifies the pte and requires the pte
lock. invalidate_range/release are called w/o pte lock held.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757038AbYA3AGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038AbYA3AGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbYA3AGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:06:09 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:56960
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbYA3AGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:06:07 -0500
Date: Wed, 30 Jan 2008 01:05:59 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, Nick Piggin <npiggin@suse.de>,
       kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address
	ranges
Message-ID: <20080130000559.GB7233@v2.random>
References: <20080128202840.974253868@sgi.com> <20080128202923.849058104@sgi.com> <20080129162004.GL7233@v2.random> <Pine.LNX.4.64.0801291153520.25300@schroedinger.engr.sgi.com> <20080129211759.GV7233@v2.random> <Pine.LNX.4.64.0801291327330.26649@schroedinger.engr.sgi.com> <20080129220212.GX7233@v2.random> <Pine.LNX.4.64.0801291407380.27104@schroedinger.engr.sgi.com> <20080130000039.GA7233@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080130000039.GA7233@v2.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2008 at 01:00:39AM +0100, Andrea Arcangeli wrote:
> get_user_pages, regular linux writes don't fault unless it's
> explicitly writeprotect, which is mandatory in a few archs, x86 not).

actually get_user_pages doesn't fault either but it calls into
set_page_dirty, however get_user_pages (unlike a userland-write) at
least requires mmap_sem in read mode and the PT lock as serialization,
userland writes don't, they just go ahead and mark the pte in hardware
w/o faults. Anyway anonymous memory these days always mapped with
dirty bit set regardless, even for read-faults, after Nick finally
rightfully cleaned up the zero-page trick.

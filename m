Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYAOUUP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYAOUUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:20:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYAOUUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:20:04 -0500
Received: from gate.crashing.org ([63.228.1.57]:39574 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbYAOUUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:20:03 -0500
Subject: Re: [PATCH] mmu notifiers #v2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, kvm-devel@lists.sourceforge.net,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       daniel.blueman@quadrics.com, holt@sgi.com, steiner@sgi.com,
       Andrew Morton <akpm@osdl.org>, Hugh Dickins <hugh@veritas.com>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <20080115124449.GK30812@v2.random>
References: <20080113162418.GE8736@v2.random>
	 <Pine.LNX.4.64.0801141154240.8300@schroedinger.engr.sgi.com>
	 <20080115124449.GK30812@v2.random>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 07:18:53 +1100
Message-Id: <1200428333.6755.0.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-15 at 13:44 +0100, Andrea Arcangeli wrote:
> On Mon, Jan 14, 2008 at 12:02:42PM -0800, Christoph Lameter wrote:
> > Hmmm... In most of the callsites we hold a writelock on mmap_sem right?
> 
> Not in all, like Marcelo pointed out in kvm-devel, so the lowlevel
> locking can't relay on the VM locks.
> 
> About your request to schedule in the mmu notifier methods this is not
> feasible right now, the notifier is often called with the pte
> spinlocks held. I wonder if you can simply post/queue an event like a
> softirq/pdflush.

Do you have cases where it's -not- called with the PTE lock held ?
 
Ben.



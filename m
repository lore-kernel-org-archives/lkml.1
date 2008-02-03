Return-Path: <linux-kernel-owner+w=401wt.eu-S934492AbYBCBdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492AbYBCBdh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 20:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbYBCBd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 20:33:28 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:48081
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947AbYBCBd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 20:33:27 -0500
Date: Sun, 3 Feb 2008 02:33:23 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 1/3] mmu_notifier: Core code
Message-ID: <20080203013323.GA7185@v2.random>
References: <20080131045750.855008281@sgi.com> <20080131045812.553249048@sgi.com> <20080201035249.GE26420@sgi.com> <Pine.LNX.4.64.0801311957250.17649@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801311957250.17649@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 07:58:40PM -0800, Christoph Lameter wrote:
> Ok. Andrea wanted the same because then he can void the begin callouts.

Exactly. I hope the page-pin will avoid me having to serialize the KVM
page fault against the start/end critical section.

BTW, I wonder if the start/end critical section API is intended to
forbid scheduling inside it. In short I wonder if GRU can is allowed
to take a spinlock in _range_start as last thing before returning, and
to release that same spinlock in _range_end as first thing, and not to
be forced to use a mutex.

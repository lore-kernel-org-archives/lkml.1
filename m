Return-Path: <linux-kernel-owner+w=401wt.eu-S933361AbYDVWlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361AbYDVWlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759300AbYDVWkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:40:53 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:60439
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758764AbYDVWkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:40:52 -0400
Date: Wed, 23 Apr 2008 00:40:48 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org,
       Hugh Dickins <hugh@veritas.com>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 04 of 12] Moves all mmu notifier methods outside the PT
	lock (first and not last
Message-ID: <20080422224048.GR24536@duo.random>
References: <ac9bb1fb3de2aa5d2721.1208872280@duo.random> <Pine.LNX.4.64.0804221323510.3640@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804221323510.3640@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:24:21PM -0700, Christoph Lameter wrote:
> Reverts a part of an earlier patch. Why isnt this merged into 1 of 12?

To give zero regression risk to 1/12 when MMU_NOTIFIER=y or =n and the
mmu notifiers aren't registered by GRU or KVM. Keep in mind that the
whole point of my proposed patch ordering from day 0, is to keep as
1/N, the absolutely minimum change that fully satisfy GRU and KVM
requirements. 4/12 isn't required by GRU/KVM so I keep it in a later
patch. I now moved mmu_notifier_unregister in a later patch too for
the same reason.

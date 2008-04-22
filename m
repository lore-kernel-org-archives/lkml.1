Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbYDVXOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbYDVXOj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 19:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbYDVXO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 19:14:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46501 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750804AbYDVXO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 19:14:27 -0400
Date: Tue, 22 Apr 2008 16:14:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <npiggin@suse.de>, Jack Steiner <steiner@sgi.com>,
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
In-Reply-To: <20080422224048.GR24536@duo.random>
Message-ID: <Pine.LNX.4.64.0804221613570.4868@schroedinger.engr.sgi.com>
References: <ac9bb1fb3de2aa5d2721.1208872280@duo.random>
 <Pine.LNX.4.64.0804221323510.3640@schroedinger.engr.sgi.com>
 <20080422224048.GR24536@duo.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008, Andrea Arcangeli wrote:

> On Tue, Apr 22, 2008 at 01:24:21PM -0700, Christoph Lameter wrote:
> > Reverts a part of an earlier patch. Why isnt this merged into 1 of 12?
> 
> To give zero regression risk to 1/12 when MMU_NOTIFIER=y or =n and the
> mmu notifiers aren't registered by GRU or KVM. Keep in mind that the
> whole point of my proposed patch ordering from day 0, is to keep as
> 1/N, the absolutely minimum change that fully satisfy GRU and KVM
> requirements. 4/12 isn't required by GRU/KVM so I keep it in a later
> patch. I now moved mmu_notifier_unregister in a later patch too for
> the same reason.

We want a full solution and this kind of patching makes the patches 
difficuilt to review because later patches revert earlier ones.
 

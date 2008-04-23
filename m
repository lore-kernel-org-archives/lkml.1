Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbYDWSRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbYDWSRJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 14:17:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753562AbYDWSQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 14:16:54 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:43096
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbYDWSQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 14:16:53 -0400
Date: Wed, 23 Apr 2008 20:16:51 +0200
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
Message-ID: <20080423181651.GH24536@duo.random>
References: <ac9bb1fb3de2aa5d2721.1208872280@duo.random> <Pine.LNX.4.64.0804221323510.3640@schroedinger.engr.sgi.com> <20080422224048.GR24536@duo.random> <Pine.LNX.4.64.0804221613570.4868@schroedinger.engr.sgi.com> <20080423134427.GW24536@duo.random> <Pine.LNX.4.64.0804231059300.12373@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804231059300.12373@schroedinger.engr.sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 11:02:18AM -0700, Christoph Lameter wrote:
> We have had this workaround effort done years ago and have been 
> suffering the ill effects of pinning for years. Had to deal with 

Yes. In addition to the pinning, there's lot of additional tlb
flushing work to do in kvm without mmu notifiers as the swapcache
could be freed by the vm the instruction after put_page unpins the
page for whatever reason.

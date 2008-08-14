Return-Path: <linux-kernel-owner+w=401wt.eu-S1758257AbYHNMSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbYHNMSo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 08:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbYHNMSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 08:18:35 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:58524 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbYHNMSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 08:18:34 -0400
Subject: Re: [rfc][patch] mm: dirty page accounting race fix
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808141210200.4398@blonde.site>
References: <20080814094537.GA741@wotan.suse.de>
	 <Pine.LNX.4.64.0808141210200.4398@blonde.site>
Content-Type: text/plain
Date: Thu, 14 Aug 2008 14:18:38 +0200
Message-Id: <1218716318.10800.209.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-14 at 12:55 +0100, Hugh Dickins wrote:

> But I got a bit distracted: mprotect's change_pte_range is
> traditionally where the pte_modify operation has been split up into
> stages on some arches, that really can be restricting permissions
> and needs to tread carefully.  Now I go to look there, I see its
> 		/*
> 		 * Avoid taking write faults for pages we know to be
> 		 * dirty.
> 		 */
> 		if (dirty_accountable && pte_dirty(ptent))
> 			ptent = pte_mkwrite(ptent);
> 
> and get rather worried: isn't that likely to be giving write permission
> to a pte in a vma we are precisely taking write permission away from?

Exactly, we do that because the page is already dirty, therefore we do
not need to trap on write to mark it dirty - at least, that was the idea
behind this optimization.




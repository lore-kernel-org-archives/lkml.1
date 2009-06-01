Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZFALQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZFALQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 07:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZFALQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 07:16:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:43153 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551AbZFALQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 07:16:43 -0400
Date: Mon, 1 Jun 2009 13:16:41 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: hugh@veritas.com, riel@redhat.com, chris.mason@oracle.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, fengguang.wu@intel.com
Subject: Re: [PATCH] [13/16] HWPOISON: The high level memory error handler in the VM v4
Message-ID: <20090601111641.GA5018@wotan.suse.de>
References: <200905291135.124267638@firstfloor.org> <20090529213539.4FACC1D0296@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529213539.4FACC1D0296@basil.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 11:35:39PM +0200, Andi Kleen wrote:
> +	mapping = page_mapping(p);
> +	if (!PageDirty(p) && !PageWriteback(p) &&
> +	    !PageAnon(p) && !PageSwapBacked(p) &&
> +	    mapping && mapping_cap_account_dirty(mapping)) {

Haven't had another good look at this yet, but if you hold the
page locked, and have done a wait_on_page_writeback, then
PageWriteback == true is a kernel bug.


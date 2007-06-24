Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbXFXXBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbXFXXBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 19:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFXXBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 19:01:43 -0400
Received: from ns.suse.de ([195.135.220.2]:53437 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbXFXXBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 19:01:42 -0400
From: Neil Brown <neilb@suse.de>
To: Nick Piggin <npiggin@suse.de>
Date: Mon, 25 Jun 2007 09:01:32 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18046.63436.472085.535177@notabene.brown>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/3] add the fsblock layer
In-Reply-To: message from Nick Piggin on Sunday June 24
References: <20070624014528.GA17609@wotan.suse.de>
	<20070624014613.GB17609@wotan.suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday June 24, npiggin@suse.de wrote:
>  
> +#define PG_blocks		20	/* Page has block mappings */
> +

I've only had a very quick look, but this line looks *very* wrong.
You should be using PG_private.

There should never be any confusion about whether ->private has
buffers or blocks attached as the only routines that ever look in
->private are address_space operations  (or should be.  I think 'NULL'
is sometimes special cased, as in try_to_release_page.  It would be
good to do some preliminary work and tidy all that up).

Why do you think you need PG_blocks?

NeilBrown

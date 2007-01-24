Return-Path: <linux-kernel-owner+w=401wt.eu-S933179AbXAXH1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbXAXH1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 02:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933176AbXAXH1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 02:27:50 -0500
Received: from mx2.suse.de ([195.135.220.15]:41262 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933170AbXAXH1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 02:27:49 -0500
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Wed, 24 Jan 2007 18:27:24 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17847.2652.255906.33304@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 002 of 4] md: Make 'repair' actually work for raid1.
In-Reply-To: message from Andrew Morton on Tuesday January 23
References: <20070123112437.29357.patches@notabene>
	<1070123002652.29462@suse.de>
	<20070123225747.caa15292.akpm@osdl.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday January 23, akpm@osdl.org wrote:
> On Tue, 23 Jan 2007 11:26:52 +1100
> NeilBrown <neilb@suse.de> wrote:
> 
> > +					for (j = 0; j < vcnt ; j++)
> > +						memcpy(page_address(sbio->bi_io_vec[j].bv_page),
> > +						       page_address(pbio->bi_io_vec[j].bv_page),
> > +						       PAGE_SIZE);
> 
> I trust these BIOs are known to only contain suitably-allocated, MD-private
> pages?  Because if these pages can be user pages then this change is
> spectacularly buggy ;)

Your trust is well placed.
This is in the 'resync' path, were all buffers are allocated in lowmem
and are full pages and so-forth, so this is perfectly safe.

NeilBrown

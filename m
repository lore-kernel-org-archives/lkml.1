Return-Path: <linux-kernel-owner+w=401wt.eu-S1757345AbXHBDn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345AbXHBDn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 23:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbXHBDnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 23:43:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58896 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244AbXHBDnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 23:43:51 -0400
From: Neil Brown <neilb@suse.de>
To: "John Stoffel" <john@stoffel.org>
Date: Thu, 2 Aug 2007 13:43:34 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18097.21222.991285.306202@notabene.brown>
Cc: Tejun Heo <teheo@suse.de>, Avi Kivity <avi@argo.co.il>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000 of 35] Refactor block layer to improve support for
 stacked devices.
In-Reply-To: message from John Stoffel on Wednesday August 1
References: <20070731112539.22428.patches@notabene>
	<46AF5534.3010902@argo.co.il>
	<46B09A92.9090409@suse.de>
	<18096.44099.826200.638485@stoffel.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday August 1, john@stoffel.org wrote:
> 
> In any case, why does something so complicated need to be a macro, why
> not a function instead?

There needs to be a macro so you can put a statement after it to be
executed "for each ..."
But you are right that it doesn't all need to be in the one macro.

The idea of something like

#define bio_for_each_segment_offset(bv, bio, _i, offset, _size) \
	for (bio_iterator_init(bio, &_i, &bv, offset, _size);	\
	     i.remaining > 0 ;					\
	     bio_next(bio, &_i, &bv))
	
with bio_iterator_init and bio_next being (inline?) functions is a
very good one.  I'll see what works.

Thanks,
NeilBrown

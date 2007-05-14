Return-Path: <linux-kernel-owner+w=401wt.eu-S1755172AbXENNe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172AbXENNe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 09:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXENNes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 09:34:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:36682 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbXENNeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 09:34:46 -0400
Date: Mon, 14 May 2007 15:34:46 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger@clusterfs.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com,
       cmm@us.ibm.com
Subject: Re: [PATCH 4/5] ext4: fallocate support in ext4
Message-ID: <20070514133445.GA28875@atrey.karlin.mff.cuni.cz>
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426181332.GD7209@amitarora.in.ibm.com> <20070503213133.d1559f52.akpm@linux-foundation.org> <20070507113753.GA5439@schatzie.adilger.int> <20070507135825.f8545a65.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070507135825.f8545a65.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 7 May 2007 05:37:54 -0600
> 
> Does the proposed implementation handle quotas correctly, btw?  Has that
> been tested?
  It seems to handle quotas fine - the block allocation itself does not
differ from the usual case, just the extents in the tree are marked as
uninitialized...
  The only question is whether DQUOT_PREALLOC_BLOCK() shouldn't be
called instead of DQUOT_ALLOC_BLOCK(). Then fallocate() won't be able to
allocate anything after the softlimit has been reached which makes some
sence but probably current behavior is kind-of less surprising.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs

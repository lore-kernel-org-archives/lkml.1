Return-Path: <linux-kernel-owner+w=401wt.eu-S1760887AbXGKFFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760887AbXGKFFq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 01:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757356AbXGKFFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 01:05:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbXGKFFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 01:05:35 -0400
From: Neil Brown <neilb@suse.de>
To: cmm@us.ibm.com
Date: Wed, 11 Jul 2007 15:05:27 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18068.25879.745638.343290@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
       nfsv4@linux-nfs.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [EXT4 set 4][PATCH 1/5] i_version:64 bit inode version
In-Reply-To: message from Neil Brown on Wednesday July 11
References: <1183275424.4010.126.camel@localhost.localdomain>
	<20070710163038.ceb2ae94.akpm@linux-foundation.org>
	<1184105380.3759.65.camel@localhost.localdomain>
	<20070710182237.e2f88bf3.akpm@linux-foundation.org>
	<18068.19667.942363.686858@notabene.brown>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It just occurred to me:

 If i_version is 64bit, then knfsd would need to be careful when
 reading it on a 32bit host.  What are the locking rules?

 Presumably it is only updated under i_mutex protection, but having to
 get i_mutex to read it would seem a little heavy handed.

 Should it use a seqlock like i_size?
 Could we use the same seqlock that i_size uses, or would we need a
 separate one?

NeilBrown

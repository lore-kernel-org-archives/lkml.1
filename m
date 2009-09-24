Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbZIXNwG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbZIXNwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 09:52:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbZIXNwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 09:52:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:32942 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZIXNwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:52:04 -0400
Date: Thu, 24 Sep 2009 15:52:17 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: [RFC] page-writeback: move indoes from one superblock together
Message-ID: <20090924155217.5ad0de4b@infradead.org>
In-Reply-To: <20090924134625.GA2507@localhost>
References: <1253775260.10618.10.camel@sli10-desk.sh.intel.com>
	<20090924100136.GA25778@localhost>
	<20090924123519.GF23126@kernel.dk>
	<20090924132252.GA696@localhost>
	<20090924132949.GH23126@kernel.dk>
	<20090924134625.GA2507@localhost>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 21:46:25 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> Note that dirty_time may not be unique, so need some workaround.  And
> the resulted rbtree implementation may not be more efficient than
> several list traversals even for a very large list (as long as
> superblocks numbers are low).
> 
> The good side is, once sb+dirty_time rbtree is implemented, it should
> be trivial to switch the key to sb+inode_number (also may not be
> unique), and to do location ordered writeback ;)

would you want to sort by dirty time, or by inode number?
(assuming inode number is loosely related to location on disk)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

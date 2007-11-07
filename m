Return-Path: <linux-kernel-owner+w=401wt.eu-S1757698AbXKGJss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757698AbXKGJss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 04:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbXKGJsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 04:48:41 -0500
Received: from lazybastard.de ([212.112.238.170]:32823 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbXKGJsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 04:48:40 -0500
Date: Wed, 7 Nov 2007 10:43:48 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Weiner <hannes-kernel@saeurebad.de>
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@skynet.ie>
Subject: Re: [patch 04/23] dentries: Extract common code to remove dentry from lru
Message-ID: <20071107094348.GB7374@lazybastard.org>
References: <20071107011130.382244340@sgi.com> <20071107011227.298491275@sgi.com> <20071107085027.GA6243@cataract>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071107085027.GA6243@cataract>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 November 2007 09:50:27 +0100, Johannes Weiner wrote:
> On Tue, Nov 06, 2007 at 05:11:34PM -0800, Christoph Lameter wrote:
> > @@ -613,11 +606,7 @@ static void shrink_dcache_for_umount_sub
> >  			spin_lock(&dcache_lock);
> >  			list_for_each_entry(loop, &dentry->d_subdirs,
> >  					    d_u.d_child) {
> > -				if (!list_empty(&loop->d_lru)) {
> > -					dentry_stat.nr_unused--;
> > -					list_del_init(&loop->d_lru);
> > -				}
> > -
> > +				dentry_lru_remove(dentry);
> 
> Shouldn't this be dentry_lru_remove(loop)?

Looks like it.  Once this is fixed, feel free to add
Acked-by: Joern Engel <joern@logfs.org>

Jörn

-- 
It does not require a majority to prevail, but rather an irate,
tireless minority keen to set brush fires in people's minds.
-- Samuel Adams

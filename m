Return-Path: <linux-kernel-owner+w=401wt.eu-S1760527AbXKNSCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527AbXKNSCy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbXKNSCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:02:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49404 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbXKNSCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:02:45 -0500
Date: Wed, 14 Nov 2007 18:02:41 +0000
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Wedgwood <cw@f00f.org>,
       linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.24-rc2 XFS nfsd hang
Message-ID: <20071114180241.GA16656@infradead.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071114152952.GA4210@infradead.org> <20071114173922.GC14254@fieldses.org> <20071114174419.GA15271@infradead.org> <20071114175322.GD14254@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114175322.GD14254@fieldses.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 12:53:22PM -0500, J. Bruce Fields wrote:
> On Wed, Nov 14, 2007 at 05:44:19PM +0000, Christoph Hellwig wrote:
> > On Wed, Nov 14, 2007 at 12:39:22PM -0500, J. Bruce Fields wrote:
> > > This must have come up before; feel free to remind me: is there any way
> > > to make the interface easier to use?  (E.g. would it help if the filldir
> > > callback could be passed a dentry?)
> > 
> > The best thing for the filesystem would be to have a readdirplus
> > (or have it folded into readdir) instead of calling into lookup
> > from ->filldir.
> 
> And the readdirplus would pass a dentry to its equivalent of ->filldir?
> Or something else?

Personally I'd prefer it to only grow a struct stat or rather it's members
But the nfsd code currently expects a dentry so this might require some
major refactoring.

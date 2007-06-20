Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbXFTRCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbXFTRCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbXFTRC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:02:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53272 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbXFTRC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:02:28 -0400
Date: Wed, 20 Jun 2007 18:02:21 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Hellwig <hch@infradead.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC PATCH 4/4] Directory listing support for union mounted directories.
Message-ID: <20070620170221.GA13237@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	Bharata B Rao <bharata@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jan Blunck <j.blunck@tu-harburg.de>
References: <20070620055050.GB4267@in.ibm.com> <20070620055418.GF4267@in.ibm.com> <20070620120947.GA3973@infradead.org> <1182349348.6225.15.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182349348.6225.15.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 10:22:28AM -0400, Trond Myklebust wrote:
> No it shouldn't. The struct file contains other stateful information
> from the open() call (such as authentication info) that needs to be
> passed into readdir.

Which is exactly that problem this tries to solve.  Once you have
union mounts you'll have a single open file descriptor for multiple
actual directories.   Beause of that you can't simply attach to the
state to the struct file but have to keep it in a different way.


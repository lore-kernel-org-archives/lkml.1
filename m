Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbYAPRre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbYAPRre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753601AbYAPRrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:47:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41498 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbYAPRrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:47:11 -0500
Date: Wed, 16 Jan 2008 17:47:06 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu, Bryn Reeves <breeves@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 04/27] kill filp_open()
Message-ID: <20080116174706.GA27224@infradead.org>
References: <20071101230826.9A4F6E00@kernel> <20071101230831.904FDE9A@kernel> <20080116005200.0165dc67.akpm@linux-foundation.org> <1200503096.22674.171.camel@localhost> <20080116171032.GA24300@infradead.org> <1200505272.22674.176.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200505272.22674.176.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 09:41:12AM -0800, Dave Hansen wrote:
> On Wed, 2008-01-16 at 17:10 +0000, Christoph Hellwig wrote:
> > 
> > But ultimatively I think we should remove this silly renaming from
> > the patch.  It doesn't help the goal and just created churn, so please
> > rename open_namei back to do_filp_open for now and put filp_open back.
> 
> It wasn't really a rename.  More that I ended up moving everything
> useful the filp_open() did to other functions, so I didn't see the need
> to keep around a stub like this:
> 
>  struct file *filp_open(const char *filename, int flags, int mode)
>  {
> 	return open_namei(AT_FDCWD, filename, flags, mode);
>  }
> 
> It would be trivial to add this stub back, though.

Well, it was a name from the caller point of view :)  You basically
merged do_filp_open and open_namei.  Given that open_namei was an
internal helper only used by do_filp_open it seems quite sensible to
keep the existing do_filp_open user interface and call the merged
function do_filp_open.  Especially as filp_open is a quite descriptive
name of what we're doing here - open the pathname and return a file
pointer for it.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757938AbYAPRNw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbYAPRNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:13:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756612AbYAPRKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:10:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42341 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbYAPRKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:10:36 -0500
Date: Wed, 16 Jan 2008 17:10:32 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Dave Hansen <haveblue@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu, hch@infradead.org, Bryn Reeves <breeves@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH 04/27] kill filp_open()
Message-ID: <20080116171032.GA24300@infradead.org>
References: <20071101230826.9A4F6E00@kernel> <20071101230831.904FDE9A@kernel> <20080116005200.0165dc67.akpm@linux-foundation.org> <1200503096.22674.171.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200503096.22674.171.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 09:04:56AM -0800, Dave Hansen wrote:
> > is using filp_open() and hence doesn't work very well.
> > 
> > A shall revert dm-loop.patch and run away.
> 
> This one's pretty easy, thank goodness.  Just replace filp_open() with
> open_namei():
> 
> 	/filp_open(/open_namei(AT_FDCWD, /

But ultimatively I think we should remove this silly renaming from
the patch.  It doesn't help the goal and just created churn, so please
rename open_namei back to do_filp_open for now and put filp_open back.

> BTW, why do we need this on top of the existing loopback driver?  Can
> they really share no code?

Yeah, given how much pain loop drivers in general are I don't think it's
a good idea to add a second one.

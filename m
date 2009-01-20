Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919AbZATMpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbZATMpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757840AbZATMpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:45:18 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:56648 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757465AbZATMpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:45:16 -0500
Date: Tue, 20 Jan 2009 07:45:15 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@sandeen.net>,
       LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>,
       Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS] 2.6.29-rc2: XFS internal error XFS_WANT_CORRUPTED_GOTO
Message-ID: <20090120124515.GA31838@infradead.org>
References: <497468C1.3000001@gmail.com> <4974CA20.6050308@sandeen.net> <20090120004611.GA6445@disturbed> <20090120112910.GA6831@infradead.org> <4975B9C4.7030401@gmail.com> <20090120114906.GA12526@infradead.org> <20090120121335.GA19182@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120121335.GA19182@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 07:13:35AM -0500, Christoph Hellwig wrote:
> On Tue, Jan 20, 2009 at 06:49:06AM -0500, Christoph Hellwig wrote:
> > > > Just curious:  do you have CONFIG_LBD set?
> > > > 
> > > Hi Christoph,
> > > 
> > > the answer is:
> > > $ grep LBD .config
> > > # CONFIG_LBD is not set
> > 
> > Ok, let me reproduce it without that set..
> 
> Ok, on 32-bit x86 without CONFIG_LBD I can reliably reproduce the issue
> with the following script:

Bisected down to:

commit 91cca5df9bc85efdabfa645f51d54259ed09f4bf
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Oct 30 16:58:01 2008 +1100

    [XFS] implement generic xfs_btree_delete/delrec

    Make the btree delete code generic. Based on a patch from David Chinner
    with lots of changes to follow the original btree implementations more
    closely. While this loses some of the generic helper routines for
    inserting/moving/removing records it also solves some of the one off bugs
    in the original code and makes it easier to verify.

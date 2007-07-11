Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbXGKJFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbXGKJFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760165AbXGKJFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:05:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59357 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759404AbXGKJFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:05:19 -0400
Date: Wed, 11 Jul 2007 10:05:16 +0100
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070711090516.GC18301@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	David Chinner <dgc@sgi.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	xfs@oss.sgi.com
References: <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com> <20070625134500.GE1951@amitarora.in.ibm.com> <20070625150320.GA8686@amitarora.in.ibm.com> <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070701225543.GW31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701225543.GW31489@sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2007 at 08:55:43AM +1000, David Chinner wrote:
> Given the current behaviour for posix_fallocate() in glibc, I think
> that retaining the same error semantic and punting the cleanup to
> userspace (where the app will fail with ENOSPC anyway) is the only
> sane thing we can do here. Trying to undo this in the kernel leads
> to lots of extra rarely used code in error handling paths...

Agreed, looks like we should stay with the user has to clean up behaviour.

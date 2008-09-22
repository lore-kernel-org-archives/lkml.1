Return-Path: <linux-kernel-owner+w=401wt.eu-S1752638AbYIVIkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbYIVIkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 04:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYIVIjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 04:39:55 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58914 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbYIVIjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 04:39:55 -0400
Date: Mon, 22 Sep 2008 04:39:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Krishna Kumar <krkumar2@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: do_generic_file_read() never gets a NULL 'filp'
	argument
Message-ID: <20080922083945.GA12658@infradead.org>
References: <20080922061610.20158.86022.sendpatchset@localhost.localdomain> <20080922013338.8e1c10ff.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080922013338.8e1c10ff.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 01:33:38AM -0700, Andrew Morton wrote:
> On Mon, 22 Sep 2008 11:46:10 +0530 Krishna Kumar <krkumar2@in.ibm.com> wrote:
> 
> > From: Krishna Kumar <krkumar2@in.ibm.com>
> > 
> > The 'filp' argument to do_generic_file_read() is never NULL.
> > 
> 
> How did you verify this?
> 
> NFS used to like passing NULL file*'s into VFS functions.  I don't
> recall whether it affected do_generic_file_read().

The only thing nfsd passed a NULL file pointer in is ->fsync on
directories.  If anyone did pass a NULL file pointer into
do_generic_file_read it would oops in it's very first line of code.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752921AbXEDJqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbXEDJqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 05:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754607AbXEDJqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 05:46:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56671 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921AbXEDJqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 05:46:11 -0400
Date: Fri, 4 May 2007 10:46:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
Subject: Re: Ext3 vs NTFS performance
Message-ID: <20070504094610.GA31607@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Anton Altaparmakov <aia21@cam.ac.uk>,
	Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org
References: <E1HjjyF-00022D-00@calista.eckenfels.net> <0733FB88-3E6E-47B7-A55D-704B5C0DB239@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0733FB88-3E6E-47B7-A55D-704B5C0DB239@cam.ac.uk>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2007 at 09:12:31AM +0100, Anton Altaparmakov wrote:
> Nothing to do with win32 functions.  Windows does NOT create sparse  
> files therefore it never can have an issue like ext3 does in this  
> scenario.  Windows will cause nice allocations to happen because of  
> this and the 1-byte writes are perfectly sensible in this regard.   
> (Although a little odd as Windows has a proper API for doing  
> preallocation so I don't get why it is not using that instead...)

Which means the right place to fix this is samba.  Samba just need
to intersept lseek and pread/pwrite to never allocate sparse files
but do the right thing instead.  Now what the right thing would probably
be a preallocate instead of writing zeroes, and we need to provide the
infrastructure for them to do it, which is in progress currently.
(And in fact samba already does the right thing for XFS if you use
the prealloc samba vfs module, which AFAIK is not the default)


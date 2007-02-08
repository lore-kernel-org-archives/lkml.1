Return-Path: <linux-kernel-owner+w=401wt.eu-S1423311AbXBHUVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423311AbXBHUVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423314AbXBHUVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:21:22 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:38331 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423311AbXBHUVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:21:21 -0500
Date: Thu, 8 Feb 2007 20:21:17 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Christoph Hellwig <hch@infradead.org>, dushistov@mail.ru,
       linux-kernel@vger.kernel.org, sparc@gentoo.org
Subject: Re: [patch] export ufs_fs.h to userspace
Message-ID: <20070208202117.GA8429@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mike Frysinger <vapier@gentoo.org>, dushistov@mail.ru,
	linux-kernel@vger.kernel.org, sparc@gentoo.org
References: <200702080246.16996.vapier@gentoo.org> <20070208200216.GA5913@infradead.org> <200702081505.36513.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702081505.36513.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 03:05:35PM -0500, Mike Frysinger wrote:
> > We should only export kernel interfaces and ufs_fs.h isn't one.  silo
> > wants it because it defines the ufs format - but the linux structs for
> > that can and do change, e.g. adding unions when we add support for the
> > gazillion+1st ufs format variant.  silo should just grab a copy of it
> > that it's happy with it and update it when it needs to support another
> > format variant (which I think is a rather theoretical issue as silo
> > only supports the solaris/sparc format IIR)
> 
> seems logical to mean, thanks for the response

Btw, if you're interesting in helping out in this area a little bit,
it would be nice if we could split up and move ufs_fs.h a little bit.
We should have an:

  fs/ufs/ufs.h for all driver internal declarations
  fs/ufs/ufs_layout.h that purely defines the layout can can be copied
                      directly into other tools that need the ufs layout
		      like silo

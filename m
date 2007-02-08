Return-Path: <linux-kernel-owner+w=401wt.eu-S1423292AbXBHUCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423292AbXBHUCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 15:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423297AbXBHUCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 15:02:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36775 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423296AbXBHUCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 15:02:18 -0500
Date: Thu, 8 Feb 2007 20:02:16 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: dushistov@mail.ru, linux-kernel@vger.kernel.org, sparc@gentoo.org
Subject: Re: [patch] export ufs_fs.h to userspace
Message-ID: <20070208200216.GA5913@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Mike Frysinger <vapier@gentoo.org>, dushistov@mail.ru,
	linux-kernel@vger.kernel.org, sparc@gentoo.org
References: <200702080246.16996.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702080246.16996.vapier@gentoo.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 08, 2007 at 02:46:16AM -0500, Mike Frysinger wrote:
> was ufs_fs.h purposefully not exported to userspace or did it just slip 
> through the cracks ?  assuming the latter scenario, the attached patch 
> touches up the relationship between ufs_fs.h and its sub headers (like 
> ufs_fs_sb.h) so that we can export it ... the silo bootloader takes advantage 
> of this header for example

We should only export kernel interfaces and ufs_fs.h isn't one.  silo
wants it because it defines the ufs format - but the linux structs for
that can and do change, e.g. adding unions when we add support for the
gazillion+1st ufs format variant.  silo should just grab a copy of it
that it's happy with it and update it when it needs to support another
format variant (which I think is a rather theoretical issue as silo
only supports the solaris/sparc format IIR)


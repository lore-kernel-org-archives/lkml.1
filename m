Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbZHPCXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbZHPCXd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 22:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZHPCXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 22:23:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54668 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485AbZHPCXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 22:23:32 -0400
Date: Sat, 15 Aug 2009 22:23:31 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Felix Blyakher <felixb@sgi.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
Subject: Re: Kernel 2.6.30.4 XFS(..?) regression (happened again)
Message-ID: <20090816022331.GA2309@infradead.org>
References: <alpine.DEB.2.00.0908080422440.12329@p34.internal.lan> <00980BBF-1206-4BEF-A8AE-B4A8DAE7EC27@sgi.com> <alpine.DEB.2.00.0908090605080.16485@p34.internal.lan> <alpine.DEB.2.00.0908110624420.22426@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908110624420.22426@p34.internal.lan>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All your traces seem to have in common that you're block on locks hold
by processed doing I/O.  Especially a lot of page locks which are
controlled by the VM and not the filesystem.  Can you try with commit
8aa7e847d834ed937a9ad37a0f2ad5b8584c1ab0 from 2.6.31-rc applied, or
better directly 2.6.3-rc6?

I would be surprised if this is something inside XFS, but running with
CONFIG_XFS_DEBUG never hurts.


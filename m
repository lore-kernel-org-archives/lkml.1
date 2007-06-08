Return-Path: <linux-kernel-owner+w=401wt.eu-S940034AbXFHIKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940034AbXFHIKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939877AbXFHH51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:57:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:53830 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939670AbXFHH50 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:57:26 -0400
Date: Fri, 8 Jun 2007 08:57:17 +0100
From: Christoph Hellwig <hch@infradead.org>
To: carsteno@de.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070608075717.GA16927@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	carsteno@de.ibm.com, Jared Hulbert <jaredeh@gmail.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	richard.griffiths@windriver.com,
	Richard Griffiths <res07ml0@verizon.net>,
	Linux-kernel@vger.kernel.org
References: <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <4666DD88.5030708@de.ibm.com> <20070606162305.GA20600@infradead.org> <46683B6A.6030306@de.ibm.com> <20070607193844.GB17144@infradead.org> <4669027E.3070406@de.ibm.com> <20070608072609.GA13115@infradead.org> <46690A39.3010402@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46690A39.3010402@de.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 09:50:17AM +0200, Carsten Otte wrote:
> I see your poing with regard to layering, and I agree to it.
> In order to do ioremap/iounmap at least we need a counterpart 
> put_xip_page thing to do iounmap in that path. Our dcss segments on 
> 390 did not raise that requirement: they had a permanent kernel mapping.
> The quiz question to me is: why don't we establish a permanenet 
> mapping of the entire thing from mount() to unmount(). That eliminates 
> the need to do iomap/iounmap, eliminates the need to have 
> put_xip_page, and eliminates to care about what layer would do this. 
> Would work for cramfs, won't work for read+write flash filesystems.

Jared's patch currently does ioremap on mount (and no iounmap at all).
That mapping needs to move from the filesystem to the device driver.

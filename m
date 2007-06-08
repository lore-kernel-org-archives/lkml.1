Return-Path: <linux-kernel-owner+w=401wt.eu-S970224AbXFHQPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970224AbXFHQPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 12:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966477AbXFHQPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 12:15:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:55225 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966199AbXFHQPb (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 12:15:31 -0400
Date: Fri, 8 Jun 2007 17:15:26 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jared Hulbert <jaredeh@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, carsteno@de.ibm.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070608161526.GA3729@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jared Hulbert <jaredeh@gmail.com>, carsteno@de.ibm.com,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	richard.griffiths@windriver.com,
	Richard Griffiths <res07ml0@verizon.net>,
	Linux-kernel@vger.kernel.org
References: <20070607193844.GB17144@infradead.org> <4669027E.3070406@de.ibm.com> <20070608072609.GA13115@infradead.org> <46690A39.3010402@de.ibm.com> <20070608075717.GA16927@infradead.org> <46690C58.7090304@de.ibm.com> <20070608080401.GA17684@infradead.org> <6934efce0706080905h253d9e3apd4168c5d14d305e5@mail.gmail.com> <20070608160929.GA3366@infradead.org> <6934efce0706080911y601a8377oad7b1251a95acd64@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6934efce0706080911y601a8377oad7b1251a95acd64@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 09:11:47AM -0700, Jared Hulbert wrote:
> >On Fri, Jun 08, 2007 at 09:05:32AM -0700, Jared Hulbert wrote:
> >> Okay so we need some driver that opens/closes this ROM.  This has been
> >> done from the dcss block device but that doesn't make sense for most
> >> embedded systems.  The MTD allows for this with point(),unpoint().
> >> That should work just fine.  It does introduce the MTD as a dependancy
> >> which is unnecessary in many systems, but it will work now.
> >
> >The Linux solution to this problem would be to introduce an option for
> >mtd write support.  That way the majority of the code doesn't heave to
> >be compiled for the read-only case but you still get a uniform interface.
> 
> You mean make an MTD-light interface possible?

I wouldn't call it that.  The interface should stay the same except that
write operations are not supported. In mtd_info you'd just have
point/unpoint and read/read_oob but no write operations and all the backing
code wouldn't be compiled in aswell.

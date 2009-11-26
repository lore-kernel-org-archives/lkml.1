Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbZKZHII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbZKZHII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 02:08:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758741AbZKZHIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 02:08:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59366 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758897AbZKZHIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 02:08:01 -0500
Date: Wed, 25 Nov 2009 23:07:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Magnus Damm <magnus.damm@gmail.com>,
       spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: SuperH MSIOF SPI Master driver
Message-Id: <20091125230748.dbb7cf09.akpm@linux-foundation.org>
In-Reply-To: <20091126064315.GA6580@linux-sh.org>
References: <20091124125531.14957.41264.sendpatchset@rxone.opensource.se>
	<20091125121152.4ccf03dc.akpm@linux-foundation.org>
	<20091126064315.GA6580@linux-sh.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Nov 2009 15:43:16 +0900 Paul Mundt <lethal@linux-sh.org> wrote:

> > > +static void sh_msiof_modify_ctr_wait(struct sh_msiof_spi_priv *p,
> > > +				     unsigned long clr, unsigned long set)
> > > +{
> > > +	unsigned long mask = clr | set;
> > > +	unsigned long data;
> > > +
> > > +	data = sh_msiof_read(p, CTR);
> > > +	data &= ~clr;
> > > +	data |= set;
> > > +	sh_msiof_write(p, CTR, data);
> > > +
> > > +	while ((sh_msiof_read(p, CTR) & mask) != set)
> > > +		;
> > 
> > hm, confidence.  No timeout needed here?
> > 
> This definitely needs a timeout, nothing involving SPI inspires
> confidence. A cpu_relax() to prevent the compiler from optimizing the
> loop out would help, too.

We generally don't bother with the relax in an IO polling loop
like this.  It involves an IO read/write which the compiler cannot fiddle
with and I believe that CPUs will generally take the opportunity to have
a little snooze while the slow IO operation is happening.

Can't hurt though ;)

Return-Path: <linux-kernel-owner+w=401wt.eu-S932600AbXBNVXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932600AbXBNVXi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 16:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932625AbXBNVXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 16:23:38 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56663 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932600AbXBNVXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 16:23:38 -0500
Subject: Re: [PATCH] use movntq version of fast_clear_page/fast_copy_page
	on Geode
From: Arjan van de Ven <arjan@infradead.org>
To: Marcelo Tosatti <marcelo@kvack.org>
Cc: Dave Jones <davej@redhat.com>, Jordan Crouse <jordan.crouse@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20070214201736.GA5794@dmt.lan>
References: <20070214190839.GA4864@dmt.lan>
	 <20070214195546.GA2005@redhat.com>  <20070214201736.GA5794@dmt.lan>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 14 Feb 2007 22:23:28 +0100
Message-Id: <1171488209.12771.463.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-14 at 18:17 -0200, Marcelo Tosatti wrote:
> On Wed, Feb 14, 2007 at 02:55:46PM -0500, Dave Jones wrote:
> > On Wed, Feb 14, 2007 at 05:08:39PM -0200, Marcelo Tosatti wrote:
> >  > 
> >  > movntq instruction is supported by Geode CPU's, so use
> >  > fast_clear_page/fast_copy_page versions that have it.
> > 
> > it's supported, but is it a win ?
> > The same was also true of the VIA C3/C7's, but due to
> > poor memory bandwidth, it turned out to be slower in most cases.
> 
> Do you have the numbers for VIA C3/C7 around?
> 
> The Geode benefits from movntq instead of movq:
> 
> [marcelo@localhost ~]$ cat /proc/cpuinfo
> processor       : 0
> vendor_id       : Geode by NSC
> cpu family      : 5
> model           : 5
> model name      : Geode(TM) Integrated Processor by National Semi
> stepping        : 2
> cpu MHz         : 364.898
> cache size      : 32 KB
> ...
> 
> [marcelo@localhost ~]$ wget http://www.fenrus.demon.nl/athlon.c
> ...


btw there is a caveat with this program: you don't see that this evicts
the data RIGHT AFTER THE COPY, so if you use it again you pay AGAIN the
memory bandwidth price...


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbYGOOlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbYGOOlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYGOOlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:41:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43122 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYGOOlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:41:04 -0400
Subject: Re: [GIT *] Allow request_firmware() to be satisfied
	from	in-kernel, use it in more drivers.
From: David Woodhouse <dwmw2@infradead.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: david@lang.hm, Arjan van de Ven <arjan@infradead.org>,
       David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       rene.herman@keyaccess.nl, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-Reply-To: <200807150823.35628.oliver@neukum.org>
References: <487C0A12.9060906@keyaccess.nl>
	 <alpine.DEB.1.10.0807142241040.6370@asgard>
	 <1216101795.27455.213.camel@shinybook.infradead.org>
	 <200807150823.35628.oliver@neukum.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 07:40:54 -0700
Message-Id: <1216132854.27455.247.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-15 at 08:23 +0200, Oliver Neukum wrote:
> Am Dienstag 15 Juli 2008 08:03:15 schrieb David Woodhouse:
> > Mostly it follows the documented recommendation, since most of the
> > touched drivers are USB drivers and you end up re-enumerating and
> > starting from scratch on resume anyway. And the remainder are so old
> > that they don't have suspend/resume support anyway. Remember, we're only
> > really updating the older drivers; newer drivers tend to use
> > request_firmware() already, and have done for years.
> 
> As for USB that was before persistance. It now allows you to even
> support a loss of power without reprobing, provided
> 
> a) the devices does not change IDs
> b) you have firmware around when reset_resume() is called

c) the driver in question actually _has_ a reset_resume() method

The old, unloved drivers which I've touched as part of this patch set
did not. In general the newer, loved drivers use request_firmware()
already.

-- 
dwmw2


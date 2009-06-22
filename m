Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbZFVXvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbZFVXvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:51:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZFVXvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:51:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:35718 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZFVXvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:51:14 -0400
Subject: Re: Regression: ppc powerstation boot hang caused by slab
 initialisation code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <1245712892.17035.39.camel@mulgrave.site>
References: <1245708635.17035.6.camel@mulgrave.site>
	 <1245709633.20062.13.camel@pasglop>
	 <1245710457.17035.9.camel@mulgrave.site>  <1245711062.4017.1.camel@pasglop>
	 <1245712892.17035.39.camel@mulgrave.site>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 09:51:07 +1000
Message-Id: <1245714667.4017.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 18:21 -0500, James Bottomley wrote:
> On Tue, 2009-06-23 at 08:51 +1000, Benjamin Herrenschmidt wrote:
> > Ah, I notice you use SLAB, that's the second report of hangs with it due to
> > the changes. You can try SLUB while I'm looking, might help.
> 
> Yes, switching to slub fixes it ... although given that the identified
> problem commit is a slab one, that's understandable ...

No, the commit actually moves all SL*B allocators earlier during boot.

Basically, the aim is to remove the need for alloc_bootmem in 90% of
boot code by making SL*B available much earlier.

Cheers,
Ben.


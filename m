Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbXE3XIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbXE3XIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 19:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbXE3XIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 19:08:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbXE3XIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 19:08:23 -0400
Date: Wed, 30 May 2007 16:08:50 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Matthias Kaehlcke" <matthias.kaehlcke@gmail.com>, axboe@kernel.dk,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] drivers/block/ub.c: use list_for_each_entry()
Message-Id: <20070530160850.0c536d55.zaitcev@redhat.com>
In-Reply-To: <a781481a0705301414t4a0c1b2epe5e14b62ec8dc872@mail.gmail.com>
References: <20070530084752.GE14284@traven>
	<20070530123840.e54d73c2.zaitcev@redhat.com>
	<a781481a0705301414t4a0c1b2epe5e14b62ec8dc872@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2007 02:44:17 +0530, "Satyam Sharma" <satyam.sharma@gmail.com> wrote:

> > > -     list_for_each(p, &sc->luns) {
> > > -             lun = list_entry(p, struct ub_lun, link);
> > > +     list_for_each_entry(lun, &sc->luns, link) {

> > This patch straddles the border of acceptable. The pointless obfuscation
> > is balanced against the removal of explicit type in list_entry() and thus
> > a possible mismatched struct. I'm not acking nor naking this.
> 
> A list_for_each() followed by list_entry() ---> list_for_each_entry()
> conversion is a pretty harmless (and desirable) conversion, IMO.
> In fact list_for_each_entry() itself uses list_entry(..., typeof(*p), ...)
> which seems to be a safer way to use list_entry() than specifying
> the type explicity/manually in its arguments, no?

I believe I have mentioned the type safety as a positive, and in fact
it's quoted above. I just didn't think it necessary to use quite as
many words explaining it until now.

The negative is the sheer number of helper functions in list.h. Personally,
I find it difficult to retain a working knowledge of them. Iterators are
particularly nasty that way. I'm thinking about dropping all of these
list_for_each_with_murky_argument_requirements_and_odd_side_effects()
and use plain for(;;), as a courtesy to someone who has to read the
code years down the road.

-- Pete

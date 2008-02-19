Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbYBSCj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbYBSCj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 21:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756193AbYBSCjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 21:39:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031AbYBSCjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 21:39:18 -0500
Date: Tue, 19 Feb 2008 02:39:00 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andi Kleen <andi@firstfloor.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH] Implement barrier support for single device DM devices
Message-ID: <20080219023900.GB4066@agk.fab.redhat.com>
Mail-Followup-To: Michael Tokarev <mjt@tls.msk.ru>,
	Andi Kleen <andi@firstfloor.org>, dm-devel@redhat.com,
	linux-kernel@vger.kernel.org, Milan Broz <mbroz@redhat.com>
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B58EAA.8040405@msgid.tls.msk.ru>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Ltd. Registered in England and Wales, number 03798903. Registered Office: Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
> Alasdair G Kergon wrote:
> > On Fri, Feb 15, 2008 at 01:08:21PM +0100, Andi Kleen wrote:
> >> Implement barrier support for single device DM devices
> > Thanks.  We've got some (more-invasive) dm patches in the works that
> > attempt to use flushing to emulate barriers where we can't just
> > pass them down like that.
> I wonder if it's worth the effort to try to implement this.

The decision got taken to allocate barrier bios to implement the basic
flush so dm has little choice in this matter now.  (If you're going to
implement barriers for flush, you might as well implement them more
generally.)

Maybe I should spell this out more clearly for those who weren't
tracking this block layer change:  AFAIK You cannot currently flush a
device-mapper block device without doing some jiggery-pokery.

> For example, how safe
> xfs is if barriers are not supported or turned off?  

The last time we tried xfs with dm it didn't seem to notice -EOPNOTSUPP
everywhere it should => recovery may find corruption.

Alasdair
-- 
agk@redhat.com

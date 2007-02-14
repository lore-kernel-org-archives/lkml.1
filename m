Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbXBNBg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbXBNBg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 20:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932210AbXBNBgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 20:36:25 -0500
Received: from gw.goop.org ([64.81.55.164]:39317 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbXBNBgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 20:36:25 -0500
Message-ID: <45D26797.5090600@goop.org>
Date: Tue, 13 Feb 2007 17:36:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Dan Hecht <dhecht@vmware.com>
CC: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@osdl.org>,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 05/21] Xen-paravirt: paravirt_ops: allocate a fixmap slot
References: <20070213221729.772002682@goop.org> <20070213221829.845132535@goop.org> <45D2649D.4080508@vmware.com>
In-Reply-To: <45D2649D.4080508@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Hecht wrote:
> Why doesn't Xen allocate the shared_info page from the pseudo-physical
> space?  Doesn't it already have to steal pages from the
> pseudo-physical space for e.g. initial page tables, console, etc?  Why
> not do the same for shared_info, and then you don't need a reserve the
> fixmap slot.

Unlike the pagetable pages or the console page, the shared info page
doesn't have a pseudo-physical address, so in order to map it we need to
directly construct a pte containing the mfn for that page.  Inserting
this mapping into the fixmap space seems like the easiest way to do
this.  It's not like a fixmap slot costs anything.

    J

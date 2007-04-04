Return-Path: <linux-kernel-owner+w=401wt.eu-S966202AbXDDAyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966202AbXDDAyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 20:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966214AbXDDAyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 20:54:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47420 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966202AbXDDAyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 20:54:50 -0400
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Woodhouse <dwmw2@infradead.org>
To: Brad Boyer <flar@allandria.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070403221002.GA13210@cynthia.pants.nu>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	 <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	 <1175642916.10567.24.camel@shinybook.infradead.org>
	 <20070403212928.GA12951@cynthia.pants.nu>
	 <1175644642.10567.31.camel@shinybook.infradead.org>
	 <20070403221002.GA13210@cynthia.pants.nu>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 20:54:10 -0400
Message-Id: <1175648051.10567.61.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 15:10 -0700, Brad Boyer wrote:
> I suppose my opinion on this shows that I didn't come from the x86
> side of Linux.

Perhaps, yes -- if you were just an x86 user you'd be unlikely to care
about the issue at all -- mostly because it's never been a problem
there. Not for the reason you imply, but just because the additional
types of serial port you encounter on an x86 machine have always got it
_right_, and had separate names and device numbers rather than abusing
major 64 and 'ttyS%d'.

>  The breakdown on this argument seems to have always
> been that the x86 people wanted 8250 to own ttyS* and most others
> wanted it shared.

But why? There's nothing special and magical about the number 64 and the
letters 't' 't' 'y' and 'S'. And if you have broken software which only
works with ttyS[0123] then you can still create device nodes or symlinks
to work around that.

If you're on a platform where 8250 serial ports _cannot_ exist, then
abusing the 8250 driver's numbers would perhaps be workable, if a little
strange -- but 8250 ports are ubiquitous. You can attach them to just
about anything, of any architecture, that Linux runs on. Except perhaps
S390.

Yes, it would be theoretically possible to come up with a way to share
minor numbers so we can use 'ttyS0' for the first serial port regardless
of what type of port it is. We could take the arch-specific hack that
SPARC has and try to move it to generic code. But what's the point?

-- 
dwmw2


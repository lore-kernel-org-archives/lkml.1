Return-Path: <linux-kernel-owner+w=401wt.eu-S1752235AbXCZLu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbXCZLu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 07:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXCZLu6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 07:50:58 -0400
Received: from smtp.osdl.org ([65.172.181.24]:54787 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140AbXCZLu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 07:50:57 -0400
Date: Mon, 26 Mar 2007 03:50:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: bryan.wu@analog.com, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH -mm] Revoke core code: fix nommu arch compiling error
 bug
Message-Id: <20070326035027.c522cdf5.akpm@linux-foundation.org>
In-Reply-To: <6017.1174908318@redhat.com>
References: <20070326024143.a226c9b2.akpm@linux-foundation.org>
	<1174904637.32691.86.camel@roc-desktop>
	<6017.1174908318@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2007 12:25:18 +0100 David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > Offending patch is
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/broken-out/nommu-hide-vm_mm-in-nommu-mode.patch,
> > which seems rather dumb.  Or at least, its changelog does a good job of
> > making it look dumb.
> 
> vm_mm is always NULL under NOMMU as it currently stands.  As far as I know,
> this has been true since the NOMMU mm stuff was first included (I'm not sure
> the VMAs of the first NOMMU mm code *had* a vm_mm).  Hugh (I think it was)
> suggested that since this was always NULL, then it should be excised from the
> struct in NOMMU-mode.
> 
> The reason is that, at the moment, VMAs are a global *shared* resource in
> NOMMU-mode.  Each process has a list of global VMAs that it subscribes to, but
> that's it.  This (a) slightly reduces the amount of metadata allocated
> (possibly), and (b) makes sharing of executables and libraries much easier.

whoa.  You live and learn.  Logical, I guess.

I agree that in that case, we just don't want vm_mm to exist in NOMMU builds - it's
better to fail at compile time.

I'll touch up the changelog for nommu-hide-vm_mm-in-nommu-mode.patch and then
I'll temporarily drop it so the blackfin guys can test their work, I guess.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYBENGx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYBENGx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 08:06:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbYBENGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 08:06:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755498AbYBENGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 08:06:39 -0500
Date: Tue, 5 Feb 2008 08:05:46 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Kosina <jkosina@suse.cz>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel list <linux-kernel@vger.kernel.org>,
       Abel Bernabeu <abel.bernabeu@gmail.com>,
       Hugh Dickins <hugh@veritas.com>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [regression] Re: brk randomization breaks columns
Message-ID: <20080205130546.GF30691@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20080204122837.GA1647@elf.ucw.cz> <Pine.LNX.4.64.0802050242440.30873@twin.jikos.cz> <20080205110632.GB3758@elf.ucw.cz> <Pine.LNX.4.64.0802051216340.30955@jikos.suse.cz> <20080205125426.GA27724@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080205125426.GA27724@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 01:54:26PM +0100, Ingo Molnar wrote:
> * Jiri Kosina <jkosina@suse.cz> wrote:
> 
> > On Tue, 5 Feb 2008, Pavel Machek wrote:
> > 
> > > > Actually, this clearly shows that either prehistoric libc.so.5 or the 
> > > > program itself are broken.
> > > I believe it shows clear regression in latest 2.6.25 kernel.
> > 
> > I am still not completely sure. It might be a regression, but it also 
> > might just trigger the bug in ancient version in libc.so.5 which might 
> > be fixed in some later version [...]
> 
> which too is a regression ...
> 
> really, lets add a sysctl for this, and a .config option that either 
> disables or enables it. Then we will default to disabled. (but users can 
> enable it - and distros can build their kernels with this .config option 
> enabled)

I don't think kernel should care about programs which are buggy and make invalid
assumptions, and that's the case here.  I remember we have been through this
5 years ago when brk randomization has been added to Red Hat kernels.  There was
one or two broken programs which made assumptions on what brk(0) is supposed
to return at program startup, everything else was ok.
For the buggy apps there is always setarch i386 -R ./the_buggy_program
so I don't think we need to add another sysctl for this.

	Jakub

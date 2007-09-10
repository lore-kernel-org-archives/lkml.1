Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbXIJTM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbXIJTM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760549AbXIJTMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:12:41 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37302 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760543AbXIJTMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:12:40 -0400
Date: Mon, 10 Sep 2007 21:14:02 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] build system: section garbage collection for vmlinux
Message-ID: <20070910191402.GB31541@uranus.ravnborg.org>
References: <200709051443.21522.vda.linux@googlemail.com> <200709061155.52661.vda.linux@googlemail.com> <20070910120140.GA29077@uranus.ravnborg.org> <200709102002.15383.vda.linux@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709102002.15383.vda.linux@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 08:02:15PM +0100, Denys Vlasenko wrote:
> On Monday 10 September 2007 13:01, Sam Ravnborg wrote:
> > > 
> > > > Doing a normal kernel build will link vmlinux three or four times.
> > > > If we introduce --gc-sections we should add a preparational link of
> > > > vmlinux where we use --gc-sections and skip it for the rest of the links
> > > > assuming that --gc-sections takes some time for ld to do.
> > > 
> > > Yes, this will speed up things a bit.
> > 
> > If we do the --gc-sections trick during the preparational link then we do
> > not use the arch supplied linker script.
> > Will it be possible to create a dedicated linker script that is valid
> > for all architectures and which only include the KEEP() directives for
> > the diverse sections?
> 
> Unfortunately, -r and --gc-sections don't mix.
> 
> x86_64-pc-linux-gnu-ld: --gc-sections and -r may not be used together
OK - so much for that optimization :-(

But then we need to annotate ALL arch linker script before introducing this.
And that bring me back to that we should put some sanity into these first.

	Sam

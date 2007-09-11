Return-Path: <linux-kernel-owner+w=401wt.eu-S1763246AbXIKLXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763246AbXIKLXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 07:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbXIKLXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 07:23:18 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:4367 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbXIKLXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 07:23:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZYjjXb/LPFDYnfVpEOXaPXFeKXEq+vL/Qm4lijgg7iCICUtX4K/jD/xJTamc8loYNTgJZw6t0OcrGrKs0sIn5WyNlNA1ddX4SOLn4gK4gEb5MJake7iBWXoStOL55AlZmJeeZOJF0IRP2HLqyz/g8Q7aYHlOYo1+/K5XJZzawaQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/3] build system: section garbage collection for vmlinux
Date: Tue, 11 Sep 2007 12:23:04 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200709051443.21522.vda.linux@googlemail.com> <200709102002.15383.vda.linux@googlemail.com> <20070910191402.GB31541@uranus.ravnborg.org>
In-Reply-To: <20070910191402.GB31541@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709111223.04724.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2007 20:14, Sam Ravnborg wrote:
> On Mon, Sep 10, 2007 at 08:02:15PM +0100, Denys Vlasenko wrote:
> > On Monday 10 September 2007 13:01, Sam Ravnborg wrote:
> > > > 
> > > > > Doing a normal kernel build will link vmlinux three or four times.
> > > > > If we introduce --gc-sections we should add a preparational link of
> > > > > vmlinux where we use --gc-sections and skip it for the rest of the links
> > > > > assuming that --gc-sections takes some time for ld to do.
> > > > 
> > > > Yes, this will speed up things a bit.
> > > 
> > > If we do the --gc-sections trick during the preparational link then we do
> > > not use the arch supplied linker script.
> > > Will it be possible to create a dedicated linker script that is valid
> > > for all architectures and which only include the KEEP() directives for
> > > the diverse sections?
> > 
> > Unfortunately, -r and --gc-sections don't mix.
> > 
> > x86_64-pc-linux-gnu-ld: --gc-sections and -r may not be used together
>
> OK - so much for that optimization :-(
> 
> But then we need to annotate ALL arch linker script before introducing this.
> And that bring me back to that we should put some sanity into these first.

I was working with x86_64 ld script and am willing to clean it up a bit.

I can impelment and test DISCARD_UNUSED_SECTIONS for x86_64 and later
for i386.

Other arches can follow when they find it interesting/worthwhile.

At first, big scary warning under "config DISCARD_UNUSED_SECTIONS"
should be enough to make people avoid it for production boxes, I hope.

Should I send next round of patches to you or to Andrew?
--
vda

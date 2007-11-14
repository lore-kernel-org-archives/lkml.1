Return-Path: <linux-kernel-owner+w=401wt.eu-S1763470AbXKNAZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763470AbXKNAZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 19:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760277AbXKNAZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 19:25:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:40916 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760839AbXKNAZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 19:25:22 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: CaT <cat@zip.com.au>
Subject: Re: [PATCH] [13/45] x86_64: Increase VDSO_TEXT_OFFSET for ancient binutils
Date: Wed, 14 Nov 2007 01:25:17 +0100
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200709211044.901175000@suse.de> <20070921204454.B51F714EFF@wotan.suse.de> <20071114002107.GA24395@zip.com.au>
In-Reply-To: <20071114002107.GA24395@zip.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711140125.17891.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 01:21:07 CaT wrote:
> On Fri, Sep 21, 2007 at 10:44:54PM +0200, Andi Kleen wrote:
> > For some reason old binutils genertate larger headers so
> > increase the text offset of the vdso to avoid linker errors.
> > 
> > Signed-off-by: Andi Kleen <ak@suse.de>
> > 
> > ---
> >  arch/x86_64/vdso/voffset.h |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux/arch/x86_64/vdso/voffset.h
> > ===================================================================
> > --- linux.orig/arch/x86_64/vdso/voffset.h
> > +++ linux/arch/x86_64/vdso/voffset.h
> > @@ -1 +1 @@
> > -#define VDSO_TEXT_OFFSET 0x500
> > +#define VDSO_TEXT_OFFSET 0x600
> 
> This still breaks under Debian sarge. There is this (german) forum
> thread about it:

iirc sarge was the one with the unfixable 2MB text pages, generating gigantic 
vDSOs. At least from my side i essentially gave up on that one because
there was no way to generate a reasonable vDSO.

You'll need to either up- or downgrade your binutils. There was only a narrow 
window where binutils were broken such, but that release unfortunately hit it.

-Andi

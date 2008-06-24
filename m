Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbYFXESn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbYFXESn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 00:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751458AbYFXESc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 00:18:32 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:41184 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751127AbYFXESa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 00:18:30 -0400
Date: Tue, 24 Jun 2008 13:15:20 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>, Peter Korsgaard <jacmet@sunsite.dk>,
       linux-kernel@vger.kernel.org, sam@ravnborg.org, dhowells@redhat.com,
       andi@firstfloor.org, "Kirill A. Shutemov" <k.shutemov@gmail.com>,
       ysato@users.sourceforge.jp, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
       linux-sh@vger.kernel.org
Subject: Re: architectures with ARCH_SUPPORTS_AOUT but no binfmt_aout
Message-ID: <20080624041520.GF22526@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
	sam@ravnborg.org, dhowells@redhat.com, andi@firstfloor.org,
	"Kirill A. Shutemov" <k.shutemov@gmail.com>,
	ysato@users.sourceforge.jp, takata@linux-m32r.org,
	linux-m32r@ml.linux-m32r.org, kyle@mcmartin.ca, matthew@wil.cx,
	grundler@parisc-linux.org, linux-parisc@vger.kernel.org,
	linux-sh@vger.kernel.org
References: <1213565555.26255.522.camel@pmac.infradead.org> <1213604973-7073-1-git-send-email-jacmet@sunsite.dk> <1213617663.26255.708.camel@pmac.infradead.org> <20080616121727.GB10854@cs181133002.pp.htv.fi> <1213619214.26255.721.camel@pmac.infradead.org> <20080617084235.GA20169@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080617084235.GA20169@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 11:42:35AM +0300, Adrian Bunk wrote:
> On Mon, Jun 16, 2008 at 01:26:54PM +0100, David Woodhouse wrote:
> >...
> > Actually, I think we can drop the preceding patch too -- it's not
> > necessary to fix the regression in 2.6.26, and dhowells suggests that we
> > might still want to use ARCH_SUPPORTS_AOUT, by making BINFMT_AOUT depend
> > on it instead of that hard-coded list of architectures.
> > 
> > If we do that, then ARCH_SUPPORTS_AOUT would need to be defined on a
> > different set of architectures to the ones it's currently defined on --
> > so I don't really want to go there before 2.6.26. I'll push just the
> > parts which were included in the mail I just sent.
> > 
> > Why _are_ there architectures which define ARCH_SUPPORTS_AOUT and have
> > <asm/a.out.h> but don't support binfmt_aout, anyway? How does that make
> > sense?
> 
> My guess would be that binfmt_aout isn't actually used there.
> 
> The affected architectures are:
> - h8300
> - m32r
> - parisc
> - sh
> - v850
> 
> v850 is broken beyond repair, and I hope my patch to remove the 
> architecture will make it into 2.6.27.
> 
> For the other 4 architectures I have Cc'ed the architecture maintainers.
> 
There was never an a.out format for any of sh/h8300/m32r. It's likely
just perpetuated damage copied over from the other ports, as in the
parisc case.

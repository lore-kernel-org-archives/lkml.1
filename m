Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbYFPM1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbYFPM1T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 08:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752651AbYFPM1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 08:27:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46339 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbYFPM1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 08:27:04 -0400
Subject: Re: [PATCH v2] export linux/a.out.h
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, dhowells@redhat.com, andi@firstfloor.org,
       "Kirill A. Shutemov" <k.shutemov@gmail.com>
In-Reply-To: <20080616121727.GB10854@cs181133002.pp.htv.fi>
References: <1213565555.26255.522.camel@pmac.infradead.org>
	 <1213604973-7073-1-git-send-email-jacmet@sunsite.dk>
	 <1213617663.26255.708.camel@pmac.infradead.org>
	 <20080616121727.GB10854@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 13:26:54 +0100
Message-Id: <1213619214.26255.721.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 15:17 +0300, Adrian Bunk wrote:
> On Mon, Jun 16, 2008 at 01:01:03PM +0100, David Woodhouse wrote:
> >...
> > David Woodhouse (6):
> >...
> >       Remove references to now-defunct CONFIG_ARCH_SUPPORTS_AOUT from defconfigs
> 
> Please don't do this kind of defconfig updates - it doesn't bring any 
> advantage but can create tons of patch conflicts.
> 
> The next time a defconfig gets updated it will anyway automatically be 
> fixed, and for defconfigs that aren't updated it doesn't create any 
> problems to keep them as they are today until they might one day get 
> updated.

OK. I did wonder about that, which is why I did it in a separate patch.

Actually, I think we can drop the preceding patch too -- it's not
necessary to fix the regression in 2.6.26, and dhowells suggests that we
might still want to use ARCH_SUPPORTS_AOUT, by making BINFMT_AOUT depend
on it instead of that hard-coded list of architectures.

If we do that, then ARCH_SUPPORTS_AOUT would need to be defined on a
different set of architectures to the ones it's currently defined on --
so I don't really want to go there before 2.6.26. I'll push just the
parts which were included in the mail I just sent.

Why _are_ there architectures which define ARCH_SUPPORTS_AOUT and have
<asm/a.out.h> but don't support binfmt_aout, anyway? How does that make
sense?

-- 
dwmw2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1755285AbYFPNW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbYFPNW1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 09:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYFPNWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 09:22:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50121 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbYFPNWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 09:22:19 -0400
Subject: Re: [PATCH v2] export linux/a.out.h
From: David Woodhouse <dwmw2@infradead.org>
To: Peter Korsgaard <jacmet@sunsite.dk>, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, dhowells@redhat.com,
       andi@firstfloor.org, "Kirill A. Shutemov" <k.shutemov@gmail.com>
In-Reply-To: <87abhl7eqo.fsf@macbook.be.48ers.dk>
References: <1213565555.26255.522.camel@pmac.infradead.org>
	 <1213604973-7073-1-git-send-email-jacmet@sunsite.dk>
	 <1213617663.26255.708.camel@pmac.infradead.org>
	 <87abhl7eqo.fsf@macbook.be.48ers.dk>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 14:22:05 +0100
Message-Id: <1213622525.26255.735.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-16 at 14:20 +0200, Peter Korsgaard wrote:
> David Woodhouse <dwmw2@infradead.org> writes:
> > On Mon, 2008-06-16 at 10:29 +0200, Peter Korsgaard wrote:
> > > Export linux/a.out.h like we do for asm/a.out.h as some applications needs
> > > it (E.G. valgrind). One minor complication is that the content is protected
> > > by an CONFIG_ARCH_SUPPORTS_AOUT ifdef, so get rid of it.
> >
> > There was a _reason_ for that ifdef, although on reflection probably not
> > a particularly good one. But unless we remove the reason for that ifdef,
> > your patch will break compilation on architectures which don't have
> > <asm/a.out.h>.
> > 
> > We should get rid of CONFIG_ARCH_SUPPORTS_AOUT entirely. The only
> > remaining users of it are fs/exec.c, which uses it entirely redundantly:
> >         #if defined(__alpha__) && defined(CONFIG_ARCH_SUPPORTS_AOUT)
> > 
> > ...and (indirectly, by virtue of being the only other file that includes
> > <linux/a.out.h> when ARCH_SUPPORTS_AOUT might be unset) fs/binfmt_elf.c,
> > which still has unnecessary references to 'struct exec' even though Andi
> > removed the support for a.out interpreters a few months ago. That can
> > just go away.
>>
> > Please see  git.infradead.org/users/dwmw2/aout-2.6.git
> >
> > David Woodhouse (6):
> >       Include <asm/a.out.h> in fs/exec.c only for Alpha.
> >       Remove last traces of a.out support from ELF loader.
> >       Remove #ifdef CONFIG_ARCH_SUPPORTS_AOUT from <linux/a.out.h>
> >       Export <linux/a.out.h> to userspace again.
> >       Remove redundant CONFIG_ARCH_SUPPORTS_AOUT
> >       Remove references to now-defunct CONFIG_ARCH_SUPPORTS_AOUT from defconfigs
> >
> > The first four are shown below, as a single combined patch.
> 
> Thanks David, looks good to me.
> 
> Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

OK, I'll send just those first four on to Linus for 2.6.26 to fix the
<linux/a.out.h> regression. The rest can wait till later, as discussed.

-- 
dwmw2


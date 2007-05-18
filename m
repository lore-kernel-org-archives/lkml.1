Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbXERCjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbXERCjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 22:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756188AbXERCjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 22:39:24 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60088 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbXERCjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 22:39:23 -0400
Subject: Re: [PATCH] ubi: kill homegrown endian macros
From: David Woodhouse <dwmw2@infradead.org>
To: Matthieu CASTET <castet.matthieu@free.fr>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <pan.2007.05.17.20.30.30@free.fr>
References: <20070517143200.GA30850@lst.de>
	 <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de>
	 <1179414590.3642.69.camel@sauron>
	 <20070517102931.6bbbad1a.akpm@linux-foundation.org>
	 <pan.2007.05.17.20.30.30@free.fr>
Content-Type: text/plain
Date: Fri, 18 May 2007 10:39:19 +0800
Message-Id: <1179455959.2859.527.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-17 at 20:30 +0000, Matthieu CASTET wrote:
> On Thu, 17 May 2007 10:29:31 -0700, Andrew Morton wrote:
> 
> > On Thu, 17 May 2007 18:09:50 +0300 Artem Bityutskiy
> > <dedekind@infradead.org> wrote:
> > 
> > umm..  I'd say what you've done in there is an improvement to the
> > exiting stuff: getting gcc to check it is better than having to use
> > sparse.
> > 
> > I'd have expected gcc to generate poorer code with your approach but I'm
> > showing zero text size changes from Christoph's patch (gcc-4.1 and
> > gcc-3.4.5).
> > 
> >
> On which arch did you try ?
> X86 where unaligned access are ok ?
> 
> On arch that don't support aligned access, packed struct access will be 
> done byte per byte (but it could be the expected behavior if there 
> unaligned access).

When I tested this on ARM, the output for je32_to_cpu et al was fine.
For _other_ structures where I'd used __attribute__((packed)) to be
safe, gcc would emit code to handle unaligned loads. But not in the
simple case where the struct has only one member.

Are you suggesting that this has changed since I did my testing?

-- 
dwmw2


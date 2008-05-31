Return-Path: <linux-kernel-owner+w=401wt.eu-S1754518AbYEaIjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbYEaIjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 04:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYEaIj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 04:39:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51337 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbYEaIj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 04:39:26 -0400
Subject: Re: [PATCHv2 26/28] firmware: allow firmware files to be built
	into kernel image
From: David Woodhouse <dwmw2@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org
In-Reply-To: <200805301508.34635.rusty@rustcorp.com.au>
References: <1211708969@pmac.infradead.org>
	 <E1K0DOO-0007ES-DU@shinybook.infradead.org>
	 <200805301508.34635.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Sat, 31 May 2008 11:39:23 +0300
Message-Id: <1212223163.8199.77.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-30 at 15:08 +1000, Rusty Russell wrote:
> 
> > +/* We have to play tricks here much like stringify() to get the
> > +   __COUNTER__ macro to be expanded as we want it */
> > +#define __fw_concat1(x,y) x##y
> > +#define __fw_concat(x,y) __fw_concat1(x,y)
> 
> Hmm, linux/module.h does this too, perhaps some enthusiast can implement 
> __concat() and use it everywhere.

Took me a while to find that... in moduleparam.h :)

Yeah, it probably makes sense to split it out, and probably add a
'uniquify' macro which properly appends __COUNTER__ to some string; PCI
fixup declarations could do with that too. I'll probably just add them
to stringify.h -- I don't think they each justify separate files of
their own. It's all just CPP magic.

Although I was actually going to drop DECLARE_BUILTIN_FIRMWARE. I'm not
doing that from C code at all any more -- it's all in asm. At this
point, it only really serves as documentation for that one patch in the
series (and yes, it's scary that such a construct really does give
people more of a clue what's going on).

-- 
dwmw2


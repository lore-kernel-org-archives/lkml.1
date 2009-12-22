Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZLVT1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZLVT1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751372AbZLVT1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:27:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45822 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbZLVT1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:27:39 -0500
Subject: Re: WARN_ON at line 380 in kernel/smp.c under 2.6.32.2 + TuxOnIce
 + KDB
From: Peter Zijlstra <peterz@infradead.org>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nigel Cunningham <nigel@tuxonice.net>
In-Reply-To: <74fd948d0912221116l477a8a71w1feadc1341fc6e21@mail.gmail.com>
References: <74fd948d0912220851v354b1704xa55fc3c88e1c300c@mail.gmail.com>
	 <1261502431.4937.38.camel@laptop>
	 <74fd948d0912221116l477a8a71w1feadc1341fc6e21@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Dec 2009 20:27:00 +0100
Message-ID: <1261510020.4937.73.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-22 at 19:16 +0000, Pedro Ribeiro wrote:
> On Tue, Dec 22, 2009 at 5:20 PM, Peter Zijlstra <peterz@infradead.org> wrote:

> > If you'd enable frame pointers the strack traces would be clearer, but
> > it looks like a bug in tux on ice, doing kmap_high() with IRQs disabled
> > or something like that.

> I enabled frame pointers, is this more useful?
> http://img684.imageshack.us/img684/5118/dsc01206m.jpg
> http://img96.imageshack.us/img96/5493/dsc01207k.jpg
> http://img33.imageshack.us/img33/7470/dsc01208lp.jpg

Those read more clearly indeed, thanks!

It really looks like what I said above, in that tux on ice is calling
kmap() from an inappropriate context.


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761615AbXEROwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761615AbXEROwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 10:52:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbXEROwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 10:52:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51091 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbXEROwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 10:52:41 -0400
Subject: Re: [PATCH] ubi: kill homegrown endian macros
From: David Woodhouse <dwmw2@infradead.org>
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: Matthieu CASTET <castet.matthieu@free.fr>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.0.99.0705180750550.8830@sigma.j-a-k-j.com>
References: <20070517143200.GA30850@lst.de>
	 <1179413443.3642.49.camel@sauron> <20070517145653.GA968@lst.de>
	 <1179414590.3642.69.camel@sauron>
	 <20070517102931.6bbbad1a.akpm@linux-foundation.org>
	 <pan.2007.05.17.20.30.30@free.fr>
	 <1179455959.2859.527.camel@shinybook.infradead.org>
	 <alpine.DEB.0.99.0705172254560.27207@sigma.j-a-k-j.com>
	 <1179458274.2859.538.camel@shinybook.infradead.org>
	 <alpine.DEB.0.99.0705180750550.8830@sigma.j-a-k-j.com>
Content-Type: text/plain
Date: Fri, 18 May 2007 22:52:39 +0800
Message-Id: <1179499959.2859.579.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 07:52 -0400, John Anthony Kazos Jr. wrote:
> Out of curiosity, why would a compiler ever insert padding in a structure 
> that has all its elements properly-aligned? 

Well, it might decide it would be nicer if some elements were aligned to
64 bits. Or to a cache line. Or something. I don't care about _why_ --
the point is that it's _allowed_ to. Hence the original use of
__attribute__((packed)).

In practice, there's no real reason why it would do such a thing, which
is why I removed the packed attribute and replaced it with a runtime
check on the size of the structures in question.

-- 
dwmw2


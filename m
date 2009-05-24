Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZEXQjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZEXQjS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 12:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbZEXQjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 12:39:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:34492 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752849AbZEXQjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 12:39:07 -0400
Date: Sun, 24 May 2009 09:38:51 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: pageexec@freemail.hu
Cc: "Larry H." <research@subreption.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
       linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Support for unconditional page sanitization
Message-ID: <20090524093851.37cbb4d6@infradead.org>
In-Reply-To: <4A191F44.24468.2C006647@pageexec.freemail.hu>
References: <20090520183045.GB10547@oblivion.subreption.com>
	<20090523182141.GK13971@oblivion.subreption.com>
	<20090523140509.5b4a59e4@infradead.org>
	<4A191F44.24468.2C006647@pageexec.freemail.hu>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 May 2009 12:19:48 +0200
pageexec@freemail.hu wrote:

> On 23 May 2009 at 14:05, Arjan van de Ven wrote:
> 
> > On Sat, 23 May 2009 11:21:41 -0700
> > "Larry H." <research@subreption.com> wrote:
> > 
> > > +static inline void sanitize_highpage(struct page *page)
> > 
> > any reason we're not reusing clear_highpage() for this?
> > (I know it's currently slightly different, but that is fixable)
> 
> KM_USER0 users are not supposed to be called from soft/hard irq
> contexts for high memory pages, something that cannot be guaranteed
> at this low level of page freeing (i.e., we could be interrupting
> a clear_highmem and overwrite its KM_USER0 mapping, leaving it dead
> in the water when we return there). in other words, sanitization
> must be able to nest within KM_USER*, so that pretty much calls for
> its own slot.

no arguement that current clear_highpage isn't a fit. I was more
thinking about using the content of sanitize_highpage(), and just
calling that clear_highpage(). (or in other words, improve
clear_highpage to be usable in more situations)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754464AbYJOUbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbYJOUbn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 16:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYJOUbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 16:31:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:48985 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbYJOUbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 16:31:32 -0400
Date: Wed, 15 Oct 2008 16:31:19 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: GIT head no longer boots on x86-64
Message-ID: <20081015163119.26595b8e@infradead.org>
In-Reply-To: <48F60D56.6040209@gmail.com>
References: <alpine.LFD.2.00.0810130752020.3288@nehalem.linux-foundation.org>
	<1223910693-28693-1-git-send-email-jirislaby@gmail.com>
	<20081013164717.7a21084a@lxorguk.ukuu.org.uk>
	<20081015115153.GA16413@elte.hu>
	<alpine.LFD.2.00.0810150758310.3288@nehalem.linux-foundation.org>
	<48F60D56.6040209@gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008 17:33:42 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Users usually do
> is_vmalloc_addr(a) ? vfree(a) : kfree(a);
> Even there it makes more sense to me.
> 

I would like to point out that I greatly dislike any and all such
abuses. Either you vmalloc something or you kmalloc it. Doing it dynamic
with no way to tell? Horrible.

(in fact I might do a patch in the opposite direction; have vmalloc()
be fancy and internally try kmalloc first, if it fails, then do the
expensive stuff)

but really, you need to know what you allocated. 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

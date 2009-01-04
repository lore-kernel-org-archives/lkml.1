Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbZADTRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbZADTRu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 14:17:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755956AbZADTRi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 14:17:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:45577 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbZADTRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 14:17:37 -0500
Date: Sun, 4 Jan 2009 11:19:27 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Message-ID: <20090104111927.1bed8269@infradead.org>
In-Reply-To: <alpine.LFD.2.00.0901041107590.3179@localhost.localdomain>
References: <20090104092430.7ffd2c41@infradead.org>
	<alpine.LFD.2.00.0901041009060.3179@localhost.localdomain>
	<20090104103104.6fdda9f2@infradead.org>
	<alpine.LFD.2.00.0901041038570.3179@localhost.localdomain>
	<20090104110559.306186c4@infradead.org>
	<alpine.LFD.2.00.0901041107590.3179@localhost.localdomain>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Jan 2009 11:11:53 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Sun, 4 Jan 2009, Arjan van de Ven wrote:
> >
> > or we declare the irq probing stuff "rare" and just make THAT fully
> > serializing....
> > do a full synchronization before starting a probe 
> 
> Yes. That's entirely possible. However, have you verified that if an
> async thread does a synchronization, it doesn't deadlock? 

an async thread can synchronize on its own cookie.
so yes if we make this a global serialize, we can't do irq autoprobing
in async context. If we can use PNP/etc for serial.. I don't think
that's a big deal.. nobody with sane hw would need to autoprobe ever.
 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

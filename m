Return-Path: <linux-kernel-owner+w=401wt.eu-S1757400AbYJMOpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400AbYJMOpZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754498AbYJMOpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:45:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:39257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349AbYJMOpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:45:11 -0400
Date: Mon, 13 Oct 2008 10:45:11 -0400
From: Arjan van de Ven <arjan@infradead.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] fastboot: Introduce an asynchronous function call
 mechanism
Message-ID: <20081013104511.477b0614@infradead.org>
In-Reply-To: <84144f020810130015j2905e568mb5819c4d4bf27279@mail.gmail.com>
References: <20081012194427.2e21c22e@infradead.org>
	<84144f020810130015j2905e568mb5819c4d4bf27279@mail.gmail.com>
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

On Mon, 13 Oct 2008 10:15:03 +0300
"Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> Hi Arjan,
> 
> On Mon, Oct 13, 2008 at 2:44 AM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > +void call_async(int pool_number, int argc, ...)
> > +{
> > +       struct async_item *item;
> > +       va_list ap;
> > +
> > +       if (argc > 4 || argc < 0) {
> > +               WARN(1, KERN_ERR "Too many arguments to async
> > function! Skipping...\n");
> > +               return;
> > +       }
> > +
> > +       item = kmalloc(sizeof(struct async_item), GFP_ATOMIC);
> 
> Why is there no check for NULL here?


because at 35000 feet it won't return NULL ;-)

but yeah thanks for spotting, I'll fix it.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

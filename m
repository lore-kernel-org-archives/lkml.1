Return-Path: <linux-kernel-owner+w=401wt.eu-S932618AbYDPQvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618AbYDPQvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758319AbYDPQvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:51:16 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35457 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757899AbYDPQvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:51:16 -0400
Date: Wed, 16 Apr 2008 09:50:26 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Ingo Oeser <ioe-lkml@rameria.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Peter Zijlstra <peterz@infradead.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Replace completions with semaphores
Message-ID: <20080416095026.658bdd21@laptopd505.fenrus.org>
In-Reply-To: <200804161831.10510.oliver@neukum.org>
References: <4803AD91.5020001@firstfloor.org>
	<200804161807.25582.ioe-lkml@rameria.de>
	<20080416161652.GK9191@parisc-linux.org>
	<200804161831.10510.oliver@neukum.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 18:31:08 +0200
Oliver Neukum <oliver@neukum.org> wrote:

> Am Mittwoch, 16. April 2008 18:16:52 schrieb Matthew Wilcox:
> > The basic idea is that you get back a cookie from the
> > kcounter_claim() which you have to hand to the kcounter_release()
> > function so it knows which one you released.  It's similar to mutex
> > debugging except
> 
> So in addition to the kcounter we need to save a token in a data
> structure? In fact, there must be a data structure that can house
> that token. So you can no longer live with a pointer just to a device
> descriptor, but every individual use of a resource must have an
> associated data structure?

yup. For kcounters there is a clear owner for each "slot".
[This is the part that makes it debugable again)

Now for non-debug builds, the space taken for the token can be.. zero 
depending on how we define the types for it.

> 
> 	Regards
> 		Oliver
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

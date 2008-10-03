Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbYJCMou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbYJCMou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 08:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbYJCMol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 08:44:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:41963 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbYJCMok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 08:44:40 -0400
Date: Fri, 3 Oct 2008 05:44:31 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: Implement personality ADDR_LIMIT_32BIT
Message-ID: <20081003054431.33e19339@infradead.org>
In-Reply-To: <20081003092550.GA8669@localhost.localdomain>
References: <1223017469-5158-1-git-send-email-kirill@shutemov.name>
	<20081003080244.GC25408@elte.hu>
	<20081003092550.GA8669@localhost.localdomain>
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

On Fri, 3 Oct 2008 12:25:52 +0300
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Fri, Oct 03, 2008 at 10:02:44AM +0200, Ingo Molnar wrote:
> > 
> > * Kirill A. Shutemov <kirill@shutemov.name> wrote:
> > 
> > > -	/* for MAP_32BIT mappings we force the legact mmap base
> > > */
> > > -	if (!test_thread_flag(TIF_IA32) && (flags & MAP_32BIT))
> > > +	/* for MAP_32BIT mappings and ADDR_LIMIT_32BIT
> > > personality we force the
> > > +	 * legact mmap base
> > > +	 */
> > 
> > please use the customary multi-line comment style:
> > 
> >   /*
> >    * Comment .....
> >    * ...... goes here:
> >    */
> > 
> > and you might use the opportunity to fix the s/legact/legacy typo
> > as well.
> 
> Ok, I'll fix it.
> 
> > 
> > but more generally, we already have ADDR_LIMIT_3GB support on x86.
> 
> Does ADDR_LIMIT_3GB really work?

if it's broken we should fix it.... not invent a new one.
Also, traditionally often personalities only start at exec() time iirc.
(but I could be wrong on that)

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

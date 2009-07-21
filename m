Return-Path: <linux-kernel-owner+w=401wt.eu-S1756212AbZGUWgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212AbZGUWgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 18:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZGUWf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 18:35:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754332AbZGUWf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 18:35:59 -0400
Date: Tue, 21 Jul 2009 15:35:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: containers@lists.linux-foundation.org, bblum@google.com,
       linux-kernel@vger.kernel.org, menage@google.com,
       vda.linux@googlemail.com, mikew@google.com
Subject: Re: [RFCv2][PATCH] flexible array implementation
Message-Id: <20090721153524.54a08fa5.akpm@linux-foundation.org>
In-Reply-To: <1248214145.13249.5671.camel@nimitz>
References: <20090721220017.60A219D3@kernel>
	<1248214145.13249.5671.camel@nimitz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 15:09:05 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Tue, 2009-07-21 at 15:00 -0700, Dave Hansen wrote:
> > 
> > The interface is dirt simple.  4 functions:
> >         alloc_flex_array()
> >         free_flex_array()
> >         flex_array_put()
> >         flex_array_get()
> > 
> > put() appends an item into the array while get() takes
> > indexes and does array-style access.
> 
> I need to update this description, but the kerneldoc comments are up to
> date.
> 
> That reminds me...  People will get somewhat weird behavior if they mix
> flex_array_append() and flex_array_put().  Is that OK?  Should
> flex_array_put() modify ->nr_elements to point to the element past the
> one that was just put()?  Should we perhaps drop the append() function
> and the ->nr_elements variable completely?

I'd say that we can drop ->append.  C arrays don't have an `append', and
callers trivially append stuff to arrays all the time.  `for (i = 0; i < ....'

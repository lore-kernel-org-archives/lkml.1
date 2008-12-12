Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbYLLNPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbYLLNPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 08:15:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758043AbYLLNPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 08:15:04 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60482 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493AbYLLNPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 08:15:03 -0500
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1229081777.15045.8.camel@pc1117.cambridge.arm.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182659.30323.43898.stgit@pc1117.cambridge.arm.com>
	 <84144f020812111401n78f980a3v101b3518ab5a3b20@mail.gmail.com>
	 <1229081777.15045.8.camel@pc1117.cambridge.arm.com>
Date: Fri, 12 Dec 2008 15:14:59 +0200
Message-Id: <1229087699.12552.11.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 11:36 +0000, Catalin Marinas wrote:
> On Fri, 2008-12-12 at 00:01 +0200, Pekka Enberg wrote:
> > On Wed, Dec 10, 2008 at 8:26 PM, Catalin Marinas
> > <catalin.marinas@arm.com> wrote:
> > > +static void put_object(struct memleak_object *object)
> > > +{
> > > +       if (!atomic_dec_and_test(&object->use_count))
> > > +               return;
> > > +
> > > +       /* should only get here after delete_object was called */
> > > +       BUG_ON(object->flags & OBJECT_ALLOCATED);
> > 
> > This could be
> > 
> >     if (WARN_ON(object->flags & OBJECT_ALLOCATED))
> >             return;
> 
> I'm not sure just warning would be enough. If this happens, its a severe
> bug in kmemleak and the tool is no longer useful (it could even leak
> memory or free already freed blocks). I could change it to a
> memleak_panic call but if the object use_count isn't reliable, the
> memleak_disable call wouldn't work properly either.

Oh, we use WARN_ON() for things like this as well to maximize the
likelihood of the oops actually reaching the user. But whatever works
for you the best.


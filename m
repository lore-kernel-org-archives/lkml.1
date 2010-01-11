Return-Path: <linux-kernel-owner+w=401wt.eu-S1753258Ab0AKO1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab0AKO1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 09:27:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752847Ab0AKO07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 09:26:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:57731 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab0AKO07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 09:26:59 -0500
Date: Mon, 11 Jan 2010 15:26:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Bert Wesarg <bert.wesarg@googlemail.com>
Cc: Andi Kleen <andi@firstfloor.org>, paulmck@linux.vnet.ibm.com,
       ebiederm@xmission.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/9] Add rcustring ADT for RCU protected strings v2
Message-ID: <20100111142658.GB28783@one.firstfloor.org>
References: <20100105315.789846878@firstfloor.org> <20100105021526.17EF2B17C2@basil.firstfloor.org> <36ca99e91001110412k17326723q5e52f6d3cc3f5e6c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36ca99e91001110412k17326723q5e52f6d3cc3f5e6c@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 01:12:41PM +0100, Bert Wesarg wrote:
> On Tue, Jan 5, 2010 at 03:15, Andi Kleen <andi@firstfloor.org> wrote:
> > Index: linux-2.6.33-rc2-ak/lib/rcustring.c
> > ===================================================================
> > --- /dev/null
> > +++ linux-2.6.33-rc2-ak/lib/rcustring.c
> 
> [ . . . ]
> 
> > +/*
> > + * Get a local private copy of a RCU protected string.
> > + * Mostly useful to get a string that is stable while sleeping.
> > + * Caller must free returned string.
> > + */
> > +char *access_rcu_string(char **str, int size, gfp_t gfp)
> > +{
> > +       char *copy = kmalloc(size, gfp);
> No check of return value from kmalloc()?
> 
> > +       if (!str)
> > +               return NULL;

The !str should be !copy right. I fixed that in my version.
Thanks for catching.

-Andi

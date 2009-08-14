Return-Path: <linux-kernel-owner+w=401wt.eu-S1755067AbZHNREO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067AbZHNREO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 13:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752753AbZHNREN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 13:04:13 -0400
Received: from www84.your-server.de ([213.133.104.84]:52137 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbZHNREN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 13:04:13 -0400
Subject: Re: [PATCH 4/6] new kfifo API v0.3 - add DEFINE_KFIFO and friends,
 add very tiny functions
From: Stefani Seibold <stefani@seibold.net>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <1250263254.15269.456.camel@Joe-Laptop.home>
References: <1250250262.19690.95.camel@wall-e>
	 <1250263254.15269.456.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Fri, 14 Aug 2009 19:03:54 +0200
Message-Id: <1250269434.5644.15.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 14.08.2009, 08:20 -0700 schrieb Joe Perches:
> On Fri, 2009-08-14 at 13:44 +0200, Stefani Seibold wrote:
> 
> Couple of trivial comments
> 
> > This is patch 4/6 of the new kfifo API:
> >  Add KFIFO_INIT - macro to generate a kfifo initializer
> 
> Is it really necessary to use KFIFO_INIT and INIT_KFIFO?
> I think it'll cause confusion and misuse.

You are right.

> > + * KFIFO_INIT - macro to generate a kfifo initializer
> > + * @s: size of the fifo buffer
> > + * @b: address of the fifo buffer
> > + */
> > +#define KFIFO_INIT(s, b) \
> > +	(struct kfifo) { \
> > +		.size	= s, \
> > +		.in	= 0, \
> > +		.out	= 0, \
> > +		.buffer = b \
> > +	}
> >
> > +/**
> > + * INIT_KFIFO - macro to initialize a with DECLARE_KFIFO declared kfifo
> > + * @name: name of the declared kfifo datatype
> > + * @size: size of the fifo buffer
> > + */
> > +#define INIT_KFIFO(name) \
> > +	name = KFIFO_INIT(sizeof(name##_buffer) - sizeof(struct kfifo), \
> > +				name##_buffer)
> 
> Perhaps
> 
> #define __kfifo_initializer ?
> 

I like your idea to rename into __kfifo_initializer. It is only for internal use.

>  
> 
> > Add INIT_KFIFO - macro to initialize a with DECLARE_KFIFO declared kfifo 
> 
> What does the description mean?

Exactly what it meas. If you declare a kfifo with DECLARE_KIFO than you
must initialize this fifo which INIT_KFIFO.
  
> 
> > Add DEFINE_KFIFO - macro to define and initialize a kfifo as a global or local object
> 
> What does this mean?  Is scope relevant to the macro?
> 

Yes, the scope is relevant, because i found no way to use unnamed unions
for global or local declarations in a way i need it.
 
> I think you should mention somewhere that these macros
> actually define 2 objects.  "name##_buffer" might have
> unexpected clashes and be prefixed with kfifo.
> maybe something like "kfifo_##name##_buffer"?
> 

Maybe name it name##_kfifo_buffer?

But before doing this i will wait for more response and for inclusion
into -mm. If i get an okay i will do a maintainance patch. It is to much
work to handle this splitted patches.

Grettings,
Stefani



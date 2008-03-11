Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbYCKCH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbYCKCH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 22:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbYCKCHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 22:07:45 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:21547 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754150AbYCKCHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 22:07:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=2irSpYCC9meFe+8LhDll0ErAXiTkMdcMjPt+YGpGayc/3tbzsf/MJV/HK+DhZCR89halU9HbJ2JIG2J8tB7QJQg/fPaFamXwF59EX4/GQg/w9BOLdXISUEufHIUXRk64rmc298B7dWts0ag9sJch1LVR3VxWM0qK2IIHQbIzyLQ=  ;
X-YMail-OSG: Q4Ph0a4VM1ngsiA5zCTXItOpa1M5NUgZ0rMbzMg38YEuqgNYGL2ysGe9GcLkUKK2a2WirPzYeg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lg@opensource.wolfsonmicro.com>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Date: Mon, 10 Mar 2008 16:39:08 -0800
User-Agent: KMail/1.9.6
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <200803071943.14805.david-b@pacbell.net> <1205061053.13653.114.camel@localhost.localdomain>
In-Reply-To: <1205061053.13653.114.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803101739.08628.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 March 2008, Liam Girdwood wrote:
> 
> > > +struct regulator *__must_check regulator_get(struct device *dev,
> > > +                                            const char *id);
> > 
> > The semantics of "id" and "dev" are unspecified in this patch,
> > so this isn't a good definition of the consumer interface!
> > 
> 
> 'id' is really the regulator name and will be renamed in the next patch.

Still not helping.  How would a driver know what names to use?
Are those names globally scoped, or local to the device?

Again, "id" and "dev" are unspecified.  I can maybe guess that
you're trying to make this look like <linux/clk.h> ... except
the clock API includes kernel doc in that header.

I *strongly* think new interfaces should not be provided without
documentation... but that's what this patch does.


> > Plus, that works more like a "lookup" than a "get" ... the
> > usual convention is that "get" and "put" update refcounts.
> > But I think I see an assumption here that a regulator may
> > have only one user...
> 
> A regulator only has one user as it's used to store some device specific
> power data. However, a regulator_dev has many users. I'll add a refcount
> on get/put.

I'm still not following.  If there's only one user, why would
you need refcounting?  If your model here is the clock API,
then you should support multiple users ... and then refcounting
is very appropriate.

- Dave



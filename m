Return-Path: <linux-kernel-owner+w=401wt.eu-S1757773AbYALQ0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773AbYALQ0p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 11:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbYALQ0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 11:26:38 -0500
Received: from wa-out-1112.google.com ([209.85.146.182]:60901 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYALQ0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 11:26:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=T1JclGvsSjQmOeWo9Ahc/XWcGWGatXmL7sZaarF+LNpA71aPc6aXyuDPwVEGvNpK0tLsY01p8nh/ht/TrgmLRkJLZw11CYzE2aV4jE7GqWiH9xgf2eq2+S96MUcOwWNPsPfOyoC0P4dtP9W1UV2tQ/SEtucbVf/s2zpdMIr3ojg=
Message-ID: <9e4733910801120826haa8905dk863ed1c8e9f420c9@mail.gmail.com>
Date: Sat, 12 Jan 2008 11:26:34 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: [i2c] [PATCH 1/5] Implement module aliasing for i2c to translate from device tree names
Cc: linuxppc-dev@ozlabs.org, i2c@lm-sensors.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080112094658.197acb08@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071220044136.20091.70984.stgit@terra.home>
	 <20071220044138.20091.31417.stgit@terra.home>
	 <20080111202015.65c3c160@hyperion.delvare>
	 <20080112094658.197acb08@hyperion.delvare>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/12/08, Jean Delvare <khali@linux-fr.org> wrote:
> Hi Jon,
>
> On Fri, 11 Jan 2008 20:20:15 +0100, Jean Delvare wrote:
> > > +{
> > > +   /* only powerpc drivers implement the id_table,
> > > +    * it is empty on other platforms */
> > > +   if (id) {
> > > +           while (id->name[0]) {
> > > +                   if (strcmp(client->driver_name, id->name) == 0)
> >
> > This doesn't look right to me. You should be comparing client->name,
> > not client->driver_name, with id->name. Where id_table is implemented,
> > client->driver_name might not even be set. I see that the next patch in
> > the series makes use of client->driver_name as well, so your code
> > "works"... but this ain't correct still.
>
> Err, scratch this (and related comments), I just realized what you were
> trying to do. That's different from what I had in mind and so I read
> your code wrong. I'll read it (and test it) again not making this
> incorrect assumption and my comments will likely be different after
> that. Well, I still think that it needs to be changed a bit, but
> probably not in the direction I suggested at first (which, I realize
> now, has its own share of issues - so it's not fair to me to point you
> there.)

The common scheme used elsewhere in the kernel for handling more than
one device in a single driver is aliases. The i2c code's existing
driver_name/type combination is a different way of implementing the
same feature. But there is no real need for driver_name/type on any
platform if aliases are used. Back in version 10 or 11 I had code in
there which replaced the two fields with aliases on all platforms but
too many people objected so I removed it..

IMHO, driver_name/type should be removed in new style drivers and
replaced with aliases on all platforms since aliases are the standard
kernel mechanism.



>
> Sorry for the trouble. I'll post updated comments later today, but I'm
> also pretty busy with other issues, some of which need to be solved
> before 2.6.24 is released so I can't really delay them.
>
> --
> Jean Delvare
>


-- 
Jon Smirl
jonsmirl@gmail.com

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbYGAWYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbYGAWYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 18:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752425AbYGAWYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 18:24:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:54720 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbYGAWYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 18:24:24 -0400
Date: Wed, 2 Jul 2008 00:24:21 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add base_hi BAR for oxsemi_840
Message-ID: <20080702002421.084d4f1c@kopernikus.site>
In-Reply-To: <20080701150026.d0ee3457.akpm@linux-foundation.org>
References: <20080701234529.67f59f49@kopernikus.site>
	<20080701150026.d0ee3457.akpm@linux-foundation.org>
Organization: SUSE LINUX Products GmbH
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.10; i686-pc-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2008-07-01 15:00]:
> > 
> > --- a/drivers/parport/parport_pc.c
> > +++ b/drivers/parport/parport_pc.c
> > @@ -2877,7 +2877,7 @@ static struct parport_pc_pci {
> >  	 * and 840 locks up if you write 1 to bit 2! */
> >  	/* oxsemi_952 */		{ 1, { { 0, 1 }, } },
> >  	/* oxsemi_954 */		{ 1, { { 0, -1 }, } },
> > -	/* oxsemi_840 */		{ 1, { { 0, -1 }, } },
> > +	/* oxsemi_840 */		{ 1, { { 0, 1 }, } },
> >  	/* aks_0100 */                  { 1, { { 0, -1 }, } },
> >  	/* mobility_pp */		{ 1, { { 0, 1 }, } },
> >  	/* netmos_9705 */               { 1, { { 0, -1 }, } }, /* untested */
> 
> My parport knowledge doesn't permit me to understand how serious the
> just-fixed bug was.  Non-functional parport?
> 
> If so, this looks like a 2.6.26 and 2.6.25.x fix?

No, for good old printers, everything works. It's just that ECR
register was not available (the base_hi stuff). Because of that,
the TRISTATE detection did not work, which meant that for me my
self-built logic analyzer which uses the parallel port did not work.

Just merge in 2.6.27 is enough. :)


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development

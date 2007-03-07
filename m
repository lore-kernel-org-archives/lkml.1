Return-Path: <linux-kernel-owner+w=401wt.eu-S965702AbXCGXAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965702AbXCGXAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945916AbXCGXAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:00:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:26934 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965717AbXCGXAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:00:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=b2lLrtoYpgT7HUz3L+8aJDDf2LEb63dHM2QHbRQPotzwF6KPXsa4NiNKMjJJ5Ivkis1k6IZO2kU+CFJ5AdMZF3cA18u2CegnVQDq4BeMHwibhsur2dKRTIwXmhAFRSLE6ivsyziVuM62HOfq1XOyX/kUJWbv35JIYH8ErJ7V6B8=
Message-ID: <45EF43E6.8060107@gmail.com>
Date: Wed, 07 Mar 2007 23:59:50 +0100
From: johan henriksson <jhn98032@gmail.com>
User-Agent: Mail/News 1.5.0.8 (X11/20061119)
MIME-Version: 1.0
To: nigel@nigel.suspend2.net
CC: linux-kernel@vger.kernel.org
Subject: Re: Radeon xpress 200m and radeonfb kinda work
References: <45ECB2D0.3080205@telia.com> <1173307167.3219.111.camel@nigel.suspend2.net>
In-Reply-To: <1173307167.3219.111.camel@nigel.suspend2.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nigel Cunningham wrote:
>  Hi.
>
>  On Tue, 2007-03-06 at 01:16 +0100, Johan Henriksson wrote:
> > Hi!
> >
> > I have gotten the radeon xpress 200m (the version without dedicated
> >  vmem) to work with radeonfb. The attached patch (against
> > linux-2.6.20.1) works for me. Since I don't have any docs for the
> > card I am unsure if the patch is 100% correct. Can someone else
> > with a 200m try it out? (I have tested it by enabling  fbcon and
> > radeonfb in the kernel  and added "video=radeonfb" to lilo. This
> > gave me a nice 1280x800 console :) )
> >
> > /Johan Henriksson
> >
> > Please CC, I'm not on the list.
> >
> > @@ -2329,7 +2332,7 @@ static int __devinit radeonfb_pci_regist /*
> > -2 is special: means  ON on mobility chips and do not * change on
> > others */ -        radeonfb_pm_init(rinfo, rinfo->is_mobility ? 1 : -1,
> > ignore_devlist, force_sleep); +        radeonfb_pm_init(rinfo,
> > -1,ignore_devlist, force_sleep);//rinfo->is_mobility ? 1 : -1);
>
>  That looks like it might break !200M. Maybe something line
>  rinfo->is_mobility && !rinfo->rs480 (with additional modifications to
>  define an rs480, of course) - or a more generic name indicating why
>  the rs480 is different?
>
>  Regards,
>
>  Nigel
>

I know, I am sorry. We could use family as in:
 
rinfo->is_mobility && rinfo->family != CHIP_FAMILY_RS480

Another solution is to add "default_dynclk" to radeonfb_setup
so that everybody with a rs480 can disable it.

I don't have the register specification for the 200m (RS480) so I don't
know why enabling "dynamic clock pm" doesn't work.

/Johan Henriksson



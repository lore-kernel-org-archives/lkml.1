Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbXJHPeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbXJHPeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 11:34:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbXJHPdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 11:33:55 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:17544 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbXJHPdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 11:33:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Uf0i8LuxbVxP11Up/aPL+9S4r7KAU5uvCzBHeYOn+MeB/xa50MvZGoDGkUUiTDFZJtKN2/n2Bt9AIOg8XWkmlun9kduMlncDHhlGm4YrKhztaT2usVa+AkRKhTpNuAni6RyV6vprBlb6MNOZifj1ZA7vXZJHRge+p86OV2nrEK8=
Message-ID: <19f34abd0710080833q76ef905dr6e47a1ec780cf153@mail.gmail.com>
Date: Mon, 8 Oct 2007 17:33:53 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [RFC][PATCH] New message-logging API (kprint)
Cc: "Rob Landley" <rob@landley.net>, "Miguel Ojeda" <maxextreme@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Holzheu" <holzheu@linux.vnet.ibm.com>,
       "Joe Perches" <joe@perches.com>,
       "Dick Streefland" <dick.streefland@altium.nl>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Jesse Barnes" <jesse.barnes@intel.com>,
       "Arnd Bergmann" <arnd@arndb.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>,
       "Emil Medve" <Emilian.Medve@freescale.com>,
       "linux@horizon.com" <linux@horizon.com>
In-Reply-To: <20071008082541.2638bb34@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1191528247.13580.11.camel@grianne>
	 <200710051126.50816.rob@landley.net>
	 <19f34abd0710052310r2043f69ew70fe8b5f9ef0493c@mail.gmail.com>
	 <200710071650.50627.rob@landley.net>
	 <20071008082541.2638bb34@freepuppy.rosehill>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> On Sun, 7 Oct 2007 16:50:49 -0500
> Rob Landley <rob@landley.net> wrote:
>
> > On Saturday 06 October 2007 1:10:26 am Vegard Nossum wrote:
> > > On 10/5/07, Rob Landley <rob@landley.net> wrote:
> > I made it about halfway through the patch and the only compile time filtering
> > I found was:
> >
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -62,7 +62,10 @@
> > #define MdpMinorShift 6
> >
> > #define DEBUG 0
> > -#define dprintk(x...) ((void)(DEBUG && printk(x)))
> > +#define dprintk(x...)\
> > +if(DEBUG) {\
> > + printk(x);\
> > +}
> >
> > If you say it does, I'll take your word for it, but there's so much churn in
> > there I didn't find it before my interest ran out...
> >
>
> BTW that change might actually break code (dangling else problems).
> The original way was safer.

Yep, thanks. I think containing it in do {} while(0) should fix, though, no?

Vegard

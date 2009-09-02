Return-Path: <linux-kernel-owner+w=401wt.eu-S1752188AbZIBNet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752188AbZIBNet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbZIBNet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:34:49 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbZIBNes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:34:48 -0400
From: Karsten Keil <isdn@linux-pingi.de>
Reply-To: isdn@linux-pingi.de
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH, v2] isdn: Fix stack corruption in isdnloop_init()
Date: Wed, 2 Sep 2009 15:34:12 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.27.25-0.1-default; KDE/4.2.1; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       isdn4linux@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>, tj@elte.hu
References: <20090902124402.GA5539@elte.hu> <20090902130336.GA16906@elte.hu> <20090902061439.6c60124c@infradead.org>
In-Reply-To: <20090902061439.6c60124c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909021534.12976.isdn@linux-pingi.de>
X-Provags-ID: V01U2FsdGVkX1/VFFAleyt7jxKFx5LI2IOTEeNzBtgm6lbVdtz
 4+/Aox/SocMdR8gsvUOe1Uz9wyzULwnP3TRmU+3dySIu68eSEO
 bj6wMoQETZ53m7VhY1IT2NMFS8w3t7x
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 2. September 2009 15:14:39 Arjan van de Ven wrote:
> On Wed, 2 Sep 2009 15:03:36 +0200
>
> Ingo Molnar <mingo@elte.hu> wrote:
> > [ v2: use strlen instead of sizeof. ]
> >
> > diff --git a/drivers/isdn/isdnloop/isdnloop.c
> > b/drivers/isdn/isdnloop/isdnloop.c index a335c85..0c8d8cb 100644
> > --- a/drivers/isdn/isdnloop/isdnloop.c
> > +++ b/drivers/isdn/isdnloop/isdnloop.c
> > @@ -1494,7 +1494,7 @@ static int __init
> >  isdnloop_init(void)
> >  {
> >  	char *p;
> > -	char rev[10];
> > +	char rev[strlen(revision)+1];
> >
> >  	if ((p = strchr(revision, ':'))) {
> >  		strcpy(rev, p + 1);
>
> now it;s a runtime variable sized array.
> NotNice(tm)

I will remove that crap revision printing code and replace it with some
easy printable version which do not need parsing this CVS revision string 
again, since we do not use CVS anymore.

Karsten


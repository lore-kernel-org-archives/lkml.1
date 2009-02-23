Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbZBWSak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbZBWSak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753666AbZBWSa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:30:29 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:21263 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753459AbZBWSa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:30:28 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=4vJh9RVsJ3SLBOvNjnVzhrmYYEC1suRgoPVB14tPtKZpPiWhubKYl5qD/iGmSeW8WWYdJMuP4gM4C2JuNxuMgk1sDAGaEWelFXAXeGe9u4E+DMEG2etF7wGf9lbCrplXGQTahgYZNcN+oviJvzON6X7nNlgnpoRbs42vflZ208Y=  ;
X-YMail-OSG: CoymRC4VM1nPk95dIqukY8UZqjWSXYo27aQxeX3FAiqQERxlg93DTsJLPIRMrsQ3mvo27HtONq9iZf2UayK2yfIY2cpUi2Lxyo0JW5yBhFlf8lDBDtVcXLbC3Rm0Gpy3oA5jtMXH4a0jQntG6gQ5v6K0OadTX3atZvV1bgC3M8oOLDr1.iVnU1qkBd2Y
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kyungmin Park <kyungmin.park@samsung.com>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [PATCH] OMAP: HSMMC: Initialize hsmmc controller registers when  resuming
Date: Mon, 23 Feb 2009 10:30:24 -0800
User-Agent: KMail/1.9.10
Cc: Kim Kyuwon <chammoru@gmail.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "drzeus-mmc@drzeus.cx" <drzeus-mmc@drzeus.cx>,
       =?utf-8?q?=EA=B9=80=EA=B7=9C=EC=9B=90?= <q1.kim@samsung.com>
References: <4d34a0a70902200400s252f48ddvfd6e0d83e91fa291@mail.gmail.com> <49A258A2.2020408@nokia.com> <9c9fda240902230426s2003d208xebeb6630c61b3bec@mail.gmail.com>
In-Reply-To: <9c9fda240902230426s2003d208xebeb6630c61b3bec@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200902231030.25137.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009, Kyungmin Park wrote:
> > Although I have not tested it, I very much doubt
> > dual-voltage cards work.  That is because VMMC1_185V
> > is zero, which has the side-effect of turning the
> > regulator off (see arch/arm/mach-omap2/mmc-twl4030.c)

Right, looks like a longstanding bug in that glue.
So IMO, no rush to fix for 2.6.29-rc ...


> It's also to difficult to test in our H/W since it's configured only
> support 3.0V.

Easily tested with a Beagle or SDP though, if you
have a 1.8V or dual-voltage card (maybe RS-MMC, as
for an N770 tablet).


> How about to separate it two phases, first fix the mmc suspend/resume
> works again, and then verify dual voltage if there are these hardware

Well, two patches for sure; I don't know that the order
will matter.  I just sent a patch fixing that code in
the current OMAP git tree, which has some fixes that are
scheduled to merge for 2.6.30-rc.

- Dave


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbXJ2LXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbXJ2LXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 07:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbXJ2LXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 07:23:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52438 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXJ2LXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 07:23:24 -0400
Date: Mon, 29 Oct 2007 12:23:03 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Johannes Stezenbach <js@linuxtv.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m &
	CONFIG_VIDEO_SAA7146_VV=y
Message-ID: <20071029112303.GA18994@elte.hu>
References: <20071026073736.GA24172@elte.hu> <20071027213057.GA15211@linuxtv.org> <20071027163932.e0a0522b.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071027163932.e0a0522b.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.1.7-deb
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0172]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> > config VIDEO_SAA7146_VV
> > 	tristate
> > 	depends on VIDEO_DEV = y || VIDEO_DEV = VIDEO_SAA7146_VV
> > 	select VIDEOBUF_DMA_SG
> > 	select VIDEO_SAA7146
> > 
> > (untested)
> 
> Nope, won't work.  I tried that last night.  VIDEO_DEV_SAA7146_VV
> has too many "select"s involved, but select doesn't follow the dependency
> chains.  IOW, as written in Documentation/kbuild/kconfig-language.txt:
> 
> 	select is evil.... select will by brute force set a symbol
> 	equal to 'y' without visiting the dependencies. So abusing
> 	select you are able to select a symbol FOO even if FOO depends
> 	on BAR that is not set.

so ... what should we do? Remove those ~7 select VIDEO_SAA7146_VV lines 
and replace them with depends on VIDEO_SAA7146_VV ?

	Ingo

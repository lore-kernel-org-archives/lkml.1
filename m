Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbXJ2MgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbXJ2MgO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 08:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXJ2Mf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 08:35:59 -0400
Received: from allen.werkleitz.de ([80.190.251.108]:47214 "EHLO
	allen.werkleitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbXJ2Mf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 08:35:58 -0400
Date: Mon, 29 Oct 2007 13:35:33 +0100
From: Johannes Stezenbach <js@linuxtv.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       linux-kernel@vger.kernel.org
Message-ID: <20071029123533.GA17331@linuxtv.org>
References: <20071026073736.GA24172@elte.hu> <20071027213057.GA15211@linuxtv.org> <20071027163932.e0a0522b.randy.dunlap@oracle.com> <20071029112303.GA18994@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029112303.GA18994@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 84.190.153.223
Subject: Re: [build bug, 2.6.24-rc1] CONFIG_VIDEO_DEV=m &
	CONFIG_VIDEO_SAA7146_VV=y
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on allen.werkleitz.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007, Ingo Molnar wrote:
> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > > config VIDEO_SAA7146_VV
> > > 	tristate
> > > 	depends on VIDEO_DEV = y || VIDEO_DEV = VIDEO_SAA7146_VV
> > > 	select VIDEOBUF_DMA_SG
> > > 	select VIDEO_SAA7146
> > > 
> > > (untested)
> > 
> > Nope, won't work.  I tried that last night.  VIDEO_DEV_SAA7146_VV
> > has too many "select"s involved, but select doesn't follow the dependency
> > chains.  IOW, as written in Documentation/kbuild/kconfig-language.txt:
> > 
> > 	select is evil.... select will by brute force set a symbol
> > 	equal to 'y' without visiting the dependencies. So abusing
> > 	select you are able to select a symbol FOO even if FOO depends
> > 	on BAR that is not set.
> 
> so ... what should we do? Remove those ~7 select VIDEO_SAA7146_VV lines 
> and replace them with depends on VIDEO_SAA7146_VV ?

Hm, the idea is that the SAA7146 driver is like a library,
and the V4L or DVB card drivers select the library functions
they need (base driver or common V4L helper functions).
The user shouldn't have to worry about those details.

But yeah, if it's not possible to do that with kbuild then
it's probably best to s/select/depends on/ for VIDEO_SAA7146_VV
and provide a meaningful help text for VIDEO_SAA7146_VV.


Johannes

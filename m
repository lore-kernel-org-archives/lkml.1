Return-Path: <linux-kernel-owner+w=401wt.eu-S1763557AbYHFAep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763557AbYHFAep (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 20:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYHFAdz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 20:33:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:47624 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154AbYHFAdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 20:33:54 -0400
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Karsten Keil <kkeil@suse.de>
Cc: Sean MacLennan <smaclennan@pikatech.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080806001845.GA25470@pingi.kke.suse.de>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de>
	 <1217910588.24157.151.camel@pasglop>
	 <20080805113111.GA6827@pingi.kke.suse.de>
	 <1217941466.24157.190.camel@pasglop>
	 <20080805172549.GA6052@pingi.kke.suse.de>
	 <alpine.LFD.1.10.0808051140250.3257@nehalem.linux-foundation.org>
	 <20080805210239.GB6052@pingi.kke.suse.de>
	 <20080805172324.45853d98@lappy.seanm.ca>
	 <alpine.LFD.1.10.0808051435260.3257@nehalem.linux-foundation.org>
	 <20080805175937.49a5ba32@lappy.seanm.ca>
	 <20080806001845.GA25470@pingi.kke.suse.de>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 10:33:35 +1000
Message-Id: <1217982815.24157.215.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 02:18 +0200, Karsten Keil wrote:
> 
> For the xhfc this may be a differnt choice, to select the access method on
> compile time, because the chip is mainly used for embedded systems, so it
> do not need to have a generic driver, the kerne is usually configured
> exactly for the hardware. On the other side, if you look into the xhfc
> chip and documentation, it is not so different from the HFC 4/8S, so maybe
> it would be possible to integrate it in hfcmulti as well.
> 
> And maybe here is a third way, to have a tristate CONFIG MEMIO,PIO,BOTH,
> which could be imlemented in the none indirect call version without
> overhead. I think I like this idea.

That's probably the best way. On powerpc, we have done a lot of work
to make it possible to have kernels support multiple platforms
even in the embedded space. You don't have to do it, but we found it
important to allow for it.

It forces to keep the code cleaner, but also makes it possible for
somebody release a range of products based on different designs to
support/release single binary images for the entire product range
(at least provided it's the same CPU core "family", we don't currently
support single binaries mixing for example 44x and 8xx processor
support). What to actually do at runtime being decided based on the
content of a "device-tree" passed to the kernel by the firmware or the
boot wrapper.

Thus, I find it a good idea to allow the option even for embedded
drivers to be built with runtime detection of access method.

Cheers,
Ben.



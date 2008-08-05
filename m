Return-Path: <linux-kernel-owner+w=401wt.eu-S1761623AbYHEXEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623AbYHEXEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 19:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbYHEXEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 19:04:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:38741 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbYHEXEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 19:04:38 -0400
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Sean MacLennan <smaclennan@pikatech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Karsten Keil <kkeil@suse.de>,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
In-Reply-To: <20080805175937.49a5ba32@lappy.seanm.ca>
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
Content-Type: text/plain
Date: Wed, 06 Aug 2008 09:04:18 +1000
Message-Id: <1217977459.24157.210.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But do we really need a generic driver that can do either? Maybe for the
> current mISDN driver, but when you get to other chip ports, say the
> xhfc, you have to select the low level interface at compile time. Or I
> should say you currently have to select at config time.

Which is pretty wrong thing to do. It might work fine for a specific
case of an embedded vendor building one ad-hoc kernel for the device,
but look at this from the point of view of a linux distribution shipping
a generic kernel image & built modules to support any HW out there...

> I'm not arguing that we *have* to do it this way. I just don't think we
> should throw out the simplest method without some thought. There is
> some precedence for a config time option, for example the 8139too
> ethernet driver.

Well, yeah, we made mistakes in the past :-)

If the size of the binary (or performances) involved in doing the two
type of IOs in a single driver is such that having the ability to
only use one is worth it (for embedded for example), then you can
provide a config option that allows to select which method to build
in the driver, but it's a good idea to allow building both with
runtime detection.

Ben.


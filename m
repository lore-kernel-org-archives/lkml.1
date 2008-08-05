Return-Path: <linux-kernel-owner+w=401wt.eu-S1763472AbYHEVhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763472AbYHEVhs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 17:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbYHEVhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 17:37:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46169 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754279AbYHEVhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 17:37:40 -0400
Date: Tue, 5 Aug 2008 14:37:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Sean MacLennan <smaclennan@pikatech.com>
cc: Karsten Keil <kkeil@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Andreas.Eversberg" <Andreas.Eversberg@versatel.de>,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Fix remaining big endian issue of hfcmulti
In-Reply-To: <20080805172324.45853d98@lappy.seanm.ca>
Message-ID: <alpine.LFD.1.10.0808051435260.3257@nehalem.linux-foundation.org>
References: <20080802151532.DE017A3C09@pingi.kke.suse.de> <1217910588.24157.151.camel@pasglop> <20080805113111.GA6827@pingi.kke.suse.de> <1217941466.24157.190.camel@pasglop> <20080805172549.GA6052@pingi.kke.suse.de> <alpine.LFD.1.10.0808051140250.3257@nehalem.linux-foundation.org>
 <20080805210239.GB6052@pingi.kke.suse.de> <20080805172324.45853d98@lappy.seanm.ca>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 5 Aug 2008, Sean MacLennan wrote:
> 
> Why not select PIO or MMIO at config time?

Umm. Then you can't run a generic driver that can do either. That's the 
worst choice of all.

As to where in the stack to do the choice - I suspect it's easier if it's 
done at the lowest level, but that can cause performance issues (ie 
testing that flag over and over again). The mmio code avoids some of the 
performance issues exactly by doing the "repeat" versions - so for some 
cases you can do the check once at the top, and then just repeat.

		Linus

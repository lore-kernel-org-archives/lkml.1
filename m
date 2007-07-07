Return-Path: <linux-kernel-owner+w=401wt.eu-S1755246AbXGGPTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbXGGPTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 11:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbXGGPTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 11:19:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbXGGPTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 11:19:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 2/2] [POWERPC] mmio ide support for mpc8349-itx target
Date: Sat, 7 Jul 2007 17:12:44 +0200
User-Agent: KMail/1.9.6
Cc: Olof Johansson <olof@lixom.net>, Vitaly Bordug <vitb@kernel.crashing.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20070707094852.9473.21013.stgit@localhost.localdomain> <20070707094900.9473.48577.stgit@localhost.localdomain> <20070707150708.GA5387@lixom.net>
In-Reply-To: <20070707150708.GA5387@lixom.net>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707071712.45173.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/Pt4I8yLy7Ro6uDEmap8QOCdCfavO3ijPpcrQ
 qEIYVeFnQ/VB6nboew8ndPx7EQpAsfnov9eWcqR5V6zQvHvCal
 ln+ioMnGoFLHN+OzxZ36w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 July 2007, Olof Johansson wrote:
> On Sat, Jul 07, 2007 at 01:49:00PM +0400, Vitaly Bordug wrote:
> > 
> > This updates relevant platform code
> > (freescale mpc8349itx target) to make the CompactFlash
> > work in TrueIDE mode.
> 
> Shouldn't you be writing a PCMCIA driver instead for the CF, so it
> handles other devices as well? Then you get storage "for free", as
> well as hotplug, etc.

CF memory cards can be in either TrueIDE mode or PCMCIA mode. If you
only need to support memory cards, you should always use True-IDE
mode, because that offers a _much_ higher throughput with PIO mode
6 (25 MB/s) or UDMA mode 6 (133MB/s), compared to the PIO mode 0
(3.3 MB/s) in PCMCIA mode.

Of course, if the bus can only sustain PIO mode 0 anyway, you can
just as well do a PCMCIA driver, and get the ability to plug in
other cards, e.g. wlan or modem cards.

	Arnd <><

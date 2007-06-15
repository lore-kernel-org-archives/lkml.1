Return-Path: <linux-kernel-owner+w=401wt.eu-S1755173AbXFOOl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173AbXFOOl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbXFOOls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:41:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:51292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbXFOOlr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:41:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linuxppc-dev@ozlabs.org
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Date: Fri, 15 Jun 2007 16:41:37 +0200
User-Agent: KMail/1.9.6
Cc: David Woodhouse <dwmw2@infradead.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@steeleye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
References: <20070615113919.142332000@pademelon.sonytel.be> <20070615120848.352093000@pademelon.sonytel.be> <1181918159.25228.543.camel@pmac.infradead.org>
In-Reply-To: <1181918159.25228.543.camel@pmac.infradead.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706151641.37788.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19rQ2xACbcsXvYTXbn9txxTO8MDjo+AI8972St
 4rjqi9L1ZPIDEkIvZpGGtURtkhImmCJz9ZiGTJ7q1ll6OE9O1S
 mWxftM/jLhvPL137BZEJw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007, David Woodhouse wrote:
> 
> On Fri, 2007-06-15 at 13:39 +0200, Geert Uytterhoeven wrote:
> > Add a Disk Storage Driver for the PS3:
> >   - Implemented as a block device driver with a dynamic major
> >   - Disk names (and partitions) are of the format ps3d%c(%u)
> >   - Uses software scatter-gather with a 64 KiB bounce buffer as the hypervisor
> >     doesn't support scatter-gather
> 
> Any particular reason why this is done as a separate block device driver
> rather than as SCSI?

Because the hypervisor interface is based on tranferring blocks, not based
on SCSI commands like the one for the optical storage drive.

The first version of this driver actually was based on SCSI command emulation,
and in an earlier round of reviews it was decided to rewrite it to use the
simpler block interface directly.

	Arnd <><

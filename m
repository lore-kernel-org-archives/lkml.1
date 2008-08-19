Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbYHSVai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbYHSVai (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:30:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbYHSVaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:30:25 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3242 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754282AbYHSVaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:30:24 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: 2.6.26/tg3 ping roundtrip times > 2000 ms on local network
From: "Michael Chan" <mchan@broadcom.com>
To: "David Miller" <davem@davemloft.net>
cc: "mh+linux-kernel@zugschlus.de" <mh+linux-kernel@zugschlus.de>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       mcarlson@broadcom.com
In-Reply-To: <20080819.132040.188336475.davem@davemloft.net>
References: <20080819172019.GA5823@torres.zugschlus.de>
 <20080819.132040.188336475.davem@davemloft.net>
Date: Tue, 19 Aug 2008 10:29:22 -0700
Message-ID: <1219166962.13090.12.camel@HP1>
MIME-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5)
X-WSS-ID: 64B5E4E24YK7723376-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-08-19 at 13:20 -0700, David Miller wrote:
> From: Marc Haber <mh+linux-kernel@zugschlus.de>
> Date: Tue, 19 Aug 2008 19:20:19 +0200
> 
> [ netdev added to CC: ]
> 
> > I have one HP DL 140 G1 running with Debian stable and a
> > locally-built, vanilla kernel. With 2.6.25.11, everything is fine.
> >
> > But, after updating to 2.6.26.2, I noticed that pinging the host on
> > the local ethernet sometimes (e.g. several times a minute, but not
> > always) results in a round-trip time of larger than two seconds. The
> > packets are not lost though, they're only severly delayed. For an ssh
> > session to the host, this feels like somebody rocking a bad network
> > connector. The same behavior is visible with 2.6.26 and 2.6.26.1.
> >
> > Going back to 2.6.25.11 immediately fixes the issue for me.
> >
> > Syslog doesn't say anything conspicious, unfortunately. As I don't
> > have local access to the box, I cannot say whether it's only the
> > network that freezes or whether it's the entire box.
> >
> > Does it make sense to test any later 2.6.25.x kernel, or is there any
> > post-2.6.26 patch available that may fix the issue for me?
> >
> > Strangely, another DL 140 from the same charge runs just fine with
> > 2.6.26.2.
> >

The may be the 2.5 second polling that was mistakenly added to the code
instead of the intended 2.5 msec.

It has been fixed a few days ago in the net-2.6 tree:

tg3: Fix firmware event timeouts

and it should be in Linus' tree very soon.  This reminds us to send the
same patch to -stable.

Thanks.



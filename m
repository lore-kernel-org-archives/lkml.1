Return-Path: <linux-kernel-owner+w=401wt.eu-S1763281AbXEVKOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763281AbXEVKOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 06:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbXEVKOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 06:14:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52564
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757015AbXEVKOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 06:14:30 -0400
Date: Tue, 22 May 2007 03:14:32 -0700 (PDT)
Message-Id: <20070522.031432.08079709.davem@davemloft.net>
To: yoshfuji@linux-ipv6.org
Cc: dada1@cosmosbay.com, webmaster@poweraudio.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: TCP_MD5 and Intel e1000
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070522.183647.75785266.yoshfuji@linux-ipv6.org>
References: <C2786969.24B46%webmaster@poweraudio.de>
	<20070522105738.f03cb83b.dada1@cosmosbay.com>
	<20070522.183647.75785266.yoshfuji@linux-ipv6.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: YOSHIFUJI Hideaki / 吉藤英明 <yoshfuji@linux-ipv6.org>
Date: Tue, 22 May 2007 18:36:47 +0900 (JST)

> In article <20070522105738.f03cb83b.dada1@cosmosbay.com> (at Tue, 22 May 2007 10:57:38 +0200), Eric Dumazet <dada1@cosmosbay.com> says:
> 
> > > I have tried to set up quagga with tcp-md5 support from kernel. All seems ok
> > > with a intel e100 NIC, but as i testetd with a intel e1000 NIC the tcp
> > > packets have an invalid md5 digest.
> > > If i run tcpdump on the mashine the packets are generated, it shows on the
> > > outgoing interface invalid md5 digests.
> > > Are there known issues about tcp-md5 and e1000 NICs?
> :
> > You could try "ethtool -K tx off", and/or other ethtool -K settings
> 
> Disabling offloading should help; currently tcp-md5 stack
> blindly copy md5-signature from the first segment
> which is not appropriate for rest of segments.

It is clear we should disable TSO for sockets making use of TCP-MD5.

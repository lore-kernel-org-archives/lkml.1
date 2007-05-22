Return-Path: <linux-kernel-owner+w=401wt.eu-S1765670AbXEVJhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765670AbXEVJhB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 05:37:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756044AbXEVJgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 05:36:50 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:32771 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827AbXEVJgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 05:36:49 -0400
Date: Tue, 22 May 2007 18:36:47 +0900 (JST)
Message-Id: <20070522.183647.75785266.yoshfuji@linux-ipv6.org>
To: dada1@cosmosbay.com
Cc: webmaster@poweraudio.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: TCP_MD5 and Intel e1000
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20070522105738.f03cb83b.dada1@cosmosbay.com>
References: <C2786969.24B46%webmaster@poweraudio.de>
	<20070522105738.f03cb83b.dada1@cosmosbay.com>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20070522105738.f03cb83b.dada1@cosmosbay.com> (at Tue, 22 May 2007 10:57:38 +0200), Eric Dumazet <dada1@cosmosbay.com> says:

> > I have tried to set up quagga with tcp-md5 support from kernel. All seems ok
> > with a intel e100 NIC, but as i testetd with a intel e1000 NIC the tcp
> > packets have an invalid md5 digest.
> > If i run tcpdump on the mashine the packets are generated, it shows on the
> > outgoing interface invalid md5 digests.
> > Are there known issues about tcp-md5 and e1000 NICs?
:
> You could try "ethtool -K tx off", and/or other ethtool -K settings

Disabling offloading should help; currently tcp-md5 stack
blindly copy md5-signature from the first segment
which is not appropriate for rest of segments.

--yoshfuji

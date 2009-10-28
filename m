Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbZJ1Ob3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbZJ1Ob3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbZJ1Ob2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:31:28 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35913 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbZJ1Ob1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:31:27 -0400
Date: Wed, 28 Oct 2009 16:31:32 +0200 (EET)
From: "=?ISO-8859-15?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@wel-95.cs.helsinki.fi
To: Arnd Hannemann <hannemann@nets.rwth-aachen.de>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
       Andreas Petlund <apetlund@simula.no>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, shemminger@vyatta.com,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/3] net: TCP thin linear timeouts
In-Reply-To: <4AE83FE4.1050309@nets.rwth-aachen.de>
Message-ID: <alpine.DEB.2.00.0910281618330.19761@wel-95.cs.helsinki.fi>
References: <4AE72079.4030504@simula.no> <4AE7262B.1060703@gmail.com> <4AE83FE4.1050309@nets.rwth-aachen.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-2146794911-1256740292=:19761"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2146794911-1256740292=:19761
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 28 Oct 2009, Arnd Hannemann wrote:

> Eric Dumazet schrieb:
> > Andreas Petlund a écrit :
> >> This patch will make TCP use only linear timeouts if the stream is 
> >> thin. This will help to avoid the very high latencies that thin 
> >> stream suffer because of exponential backoff. This mechanism is only 
> >> active if enabled by iocontrol or syscontrol and the stream is 
> >> identified as thin. 

...I don't see how high latency is in any connection to stream being 
"thin" or not btw. If all ACKs are lost it usually requires silence for 
the full RTT, which affects a stream regardless of its size. ...If not all 
ACKs are lost, then the dupACK approach in the other patch should cover 
it already.

> However, addressing the proposal:
> I wonder how one can seriously suggest to just skip congestion response 
> during timeout-based loss recovery? I believe that in a heavily 
> congested scenarios, this would lead to a goodput disaster... Not to 
> mention that in a heavily congested scenario, suddenly every flow will 
> become "thin", so this will even amplify the problems. Or did I miss 
> something?

Good point. I suppose such an under-provisioned network can certainly be
there. I have heard that at least some people who remove exponential back 
off apply it later on nth retransmission as very often there really isn't 
such a super heavy congestion scenario but something completely unrelated 
to congestion which causes the RTO.

-- 
 i.
--8323329-2146794911-1256740292=:19761--

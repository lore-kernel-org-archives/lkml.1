Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbYHSW4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbYHSW4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 18:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYHSWxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 18:53:53 -0400
Received: from fmailhost02.isp.att.net ([207.115.11.52]:45711 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbYHSWxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 18:53:52 -0400
X-Greylist: delayed 80419 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Aug 2008 18:53:51 EDT
X-Originating-IP: [65.12.36.233]
Date: Tue, 19 Aug 2008 17:53:34 -0500
From: Jay Cliburn <jacliburn@bellsouth.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       link@miggy.org, ian@jeffray.co.uk, csnook@redhat.com,
       jie.yang@atheros.com, m@fhloston.org, davem@davemloft.net
Subject: Re: [PATCH] atl1: disable TSO by default
Message-ID: <20080819175334.28dc1c8e@osprey.hogchain.net>
In-Reply-To: <E1KVQyr-0001Ui-00@gondolin.me.apana.org.au>
References: <20080818192813.0d0dc1fd@osprey.hogchain.net>
	<E1KVQyr-0001Ui-00@gondolin.me.apana.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAIVBMVEV2dXOAgYNxSD+aemaal42A
 gIBqYV2UU07Ik5GXfoFMRTdbKiVwAAACbUlEQVQ4jXXTzWvbMBQAcG3EZsmt0Owc3pgNPo1oxNFt
 pQnEN3Wrs3UnkdXq5tOwIdq9Pci3gUqJexo55KC/cs9O/dHBRIiMfpb03rNE4v800jxIQRzsXPEP
 jDwndhNelo9/ngE/SFdKmZQnfOT0YSSlQBKLiJBDH6w9SPwlp5evpduDr9biQqkV8Rh7p4NRNSO1
 4BHhpjLpIK2gWksIgl0LPLCHoBIcX6dp2kGKMYnfGJnjIFungZeuHA6dhSvqLXrA1zJmVKayCu1w
 DKuGAU+WZRRCsLdBFXgLl2Sw3N2ZEJDAn3VwEV9FK12YUGW+yqlIWiD30U5rbSi2efGuhRfxEXRB
 8e+uJE/AL5z78xrqVg6aBHlMTj9V7x/RJOMGHHI11ItVUW+B0JakkGPcUsJNHuY7/ZA04X4xwQ/D
 3I0FGgaT8iFponoJ26F+sNbu51O7l7QHHtNTbxMc5o/W+kw0S31Ub5i+pQBq/hjYPVPbJ/ic/aoC
 pbTQtxlAvvnZgNod89Y4D2sFXpMHZWU1yHb6Ft+g2aTJY84iY2iY4ySGmWdvmxlDprHkCgd1yDRV
 bXVfFQiZjyuyaU5p1pZkTbXBbxRagAyU2rZfcH2tTQ7+FpNQ4Ofb7lxdFzTHDGqAvHdEv0cIezi2
 be+0vzdUqawaDSATHfB7itGiIfrQu2p8UQOOooHTh5lUPn6lva/qQrWwQpCUTv08hGe3dkU9KWmJ
 Z2EGpAeDFc3kN8oMNbNJ/AzMFERUhjmehB7ws6XBTTnfeOXT9T/C9dn4HEshpPWIjDvgi5Px2U0G
 Hl7dzaQHg8U4Xn6oa4g3vVnqLz3ribDLdyFmAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 23:10:37 +1000
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Jay Cliburn <jacliburn@bellsouth.net> wrote:

> >        netdev->features |= NETIF_F_LLTX;
> 
> Another new driver using LLTX, this is not good when we're trying
> to get rid of it.

The atl1 driver was merged in the spring of 2007, so I'm not sure I
consider it new (but your kernel development time horizon is undoubtedly
*way* longer than mine, so you may indeed consider it new). It was
basically a vendor driver that we modified to conform to kernel coding
standards. It started life, we believe, as pretty much a clone of the
e1000 driver circa 2005, so that's likely where it's use of LLTX
came from.

> 
> Perhaps we could just kill it by ignoring the LLTX flag and always
> grabbing the xmit lock.  That should be safe as long as none of these
> drivers grab the xmit lock within their private locks.

I'd be happy to gin up a patch if you could point me to a driver that
implements properly what you're asking.

Thanks,
Jay

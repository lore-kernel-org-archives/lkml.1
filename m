Return-Path: <linux-kernel-owner+w=401wt.eu-S1761536AbZJJBOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761536AbZJJBOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 21:14:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbZJJBOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 21:14:34 -0400
Received: from stl-smtpout-01.boeing.com ([130.76.96.56]:34371 "EHLO
	stl-smtpout-01.boeing.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335AbZJJBOd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 21:14:33 -0400
X-Greylist: delayed 2244 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Oct 2009 21:14:32 EDT
From: "Templin, Fred L" <Fred.L.Templin@boeing.com>
To: Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
CC: "stable-review@kernel.org" <stable-review@kernel.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       Sascha Hlusiak <contact@saschahlusiak.de>,
       "David S. Miller" <davem@davemloft.net>,
       =?iso-2022-jp?B?WU9TSElGVUpJIEhpZGVha2kgLyA=?=
	 =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= <yoshfuji@linux-ipv6.org>
Date: Fri, 9 Oct 2009 17:34:49 -0700
Subject: RE: [patch 37/37] sit: fix off-by-one in ipip6_tunnel_get_prl
Thread-Topic: [patch 37/37] sit: fix off-by-one in ipip6_tunnel_get_prl
Thread-Index: AcpJOg/FjvKaDlXITfumPnfH12A71AABi3qQ
Message-ID: <12F4112206976147A34FEC0277597CCF27A416492F@XCH-NW-15V.nw.nos.boeing.com>
References: <20091009233411.852013234@mini.kroah.org>
 <20091009233440.786680001@mini.kroah.org>
In-Reply-To: <20091009233440.786680001@mini.kroah.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
x-tm-as-product-ver: SMEX-8.0.0.1181-5.600.1016-16936.002
x-tm-as-result: No--57.374800-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wait a moment - I remember now that this code came
from Yoshifuji, and I believe there was a reason for
the cmax+1. The application is expected to know this
and to post a large enough buffer.

Can we put this on hold until I have had a chance to
check my e-mail archives and my local iproute changes
(will respond on monday)?

Thanks - Fred
fred.l.templin@boeing.com

> -----Original Message-----
> From: Greg KH [mailto:gregkh@suse.de]
> Sent: Friday, October 09, 2009 4:35 PM
> To: linux-kernel@vger.kernel.org; stable@kernel.org
> Cc: stable-review@kernel.org; torvalds@linux-foundation.org; akpm@linux-foundation.org;
> alan@lxorguk.ukuu.org.uk; Sascha Hlusiak; Templin, Fred L; David S. Miller
> Subject: [patch 37/37] sit: fix off-by-one in ipip6_tunnel_get_prl
> 
> 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> From: Sascha Hlusiak <contact@saschahlusiak.de>
> 
> [ Upstream commit 298bf12ddb25841804f26234a43b89da1b1c0e21 ]
> 
> When requesting all prl entries (kprl.addr == INADDR_ANY) and there are
> more prl entries than there is space passed from userspace, the existing
> code would always copy cmax+1 entries, which is more than can be handled.
> 
> This patch makes the kernel copy only exactly cmax entries.
> 
> Signed-off-by: Sascha Hlusiak <contact@saschahlusiak.de>
> Acked-By: Fred L. Templin <Fred.L.Templin@boeing.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  net/ipv6/sit.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -313,7 +313,7 @@ static int ipip6_tunnel_get_prl(struct i
> 
>  	c = 0;
>  	for (prl = t->prl; prl; prl = prl->next) {
> -		if (c > cmax)
> +		if (c >= cmax)
>  			break;
>  		if (kprl.addr != htonl(INADDR_ANY) && prl->addr != kprl.addr)
>  			continue;
> 


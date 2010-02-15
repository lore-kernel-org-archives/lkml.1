Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab0BOPYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:24:53 -0500
Received: from stinky.trash.net ([213.144.137.162]:62972 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab0BOPYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:24:52 -0500
Message-ID: <4B79673B.7050908@trash.net>
Date: Mon, 15 Feb 2010 16:24:43 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Moore <paul.moore@hp.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Sridhar Samudrala <sri@us.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tun: socket filter support
References: <cover.1266144917.git.mst@redhat.com> <20100214110110.GC30182@redhat.com>
In-Reply-To: <20100214110110.GC30182@redhat.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael S. Tsirkin wrote:
> +	case TUNATTACHFILTER:
> +		/* Can be set only for TAPs */
> +		ret = -EINVAL;
> +		if ((tun->flags & TUN_TYPE_MASK) != TUN_TAP_DEV)
> +			break;
> +		ret = -EFAULT;
> +		if (copy_from_user(&fprog, argp, sizeof(fprog)))
> +			break;
> +
> +		ret = sk_attach_filter(&fprog, tun->socket.sk);
> +		break;
> +
> +	case TUNDETACHFILTER:
> +		/* Can be set only for TAPs */
> +		ret = -EINVAL;
> +		if ((tun->flags & TUN_TYPE_MASK) != TUN_TAP_DEV)
> +			break;
> +		ret = sk_detach_filter(tun->socket.sk);
> +		break;
> +

I'm not sure how the tun socket is exposed, but won't the regular
SO_ATTACH_FILTER/SO_DETACH_FILTER setsockopts already work for
tun sockets?

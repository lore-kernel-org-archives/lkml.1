Return-Path: <linux-kernel-owner+w=401wt.eu-S1763203AbXKHU13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763203AbXKHU13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 15:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761407AbXKHU1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 15:27:19 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43856 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761348AbXKHU1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 15:27:18 -0500
Date: Thu, 8 Nov 2007 22:27:16 +0200 (EET)
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
X-X-Sender: ijjarvin@kivilampi-30.cs.helsinki.fi
To: Rainer Jochem <rainer.jochem@mpi-sb.mpg.de>
cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
       kaber@trash.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       pcernko@mpi-sws.mpg.de
Subject: Re: [PATCH] ipconfig.c : implement DHCP Class-identifier
In-Reply-To: <20071108143205.GA22490@mpi-sb.mpg.de>
Message-ID: <Pine.LNX.4.64.0711082225330.26833@kivilampi-30.cs.helsinki.fi>
References: <20071108143205.GA22490@mpi-sb.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Nov 2007, Rainer Jochem wrote:

> @@ -620,6 +622,17 @@ ic_dhcp_init_options(u8 *options)
>  		*e++ = sizeof(ic_req_params);
>  		memcpy(e, ic_req_params, sizeof(ic_req_params));
>  		e += sizeof(ic_req_params);
> +
> +		// Send it only if the according kernel parameter was set

No C99 comments please. Though I'm not sure if this comment is that 
necessary anyway...

> +		if (*vendor_class_identifier) {
> +			printk(KERN_INFO "Sending class identifier \"%s\"\n",
> +			       vendor_class_identifier);
> +			*e++ = 60;	/* Class-identifier */
> +			*e++ = strlen(vendor_class_identifier);
> +			memcpy(e, vendor_class_identifier,
> +			       strlen(vendor_class_identifier));
> +			e += strlen(vendor_class_identifier);
> +		}
>  	}
>  
>  	*e++ = 255;	/* End of the list */

-- 
 i.

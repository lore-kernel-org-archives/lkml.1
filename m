Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXLDEYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXLDEYw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 23:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbXLDEYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 23:24:45 -0500
Received: from koto.vergenet.net ([210.128.90.7]:41835 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbXLDEYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 23:24:44 -0500
Date: Tue, 4 Dec 2007 13:24:40 +0900
From: Simon Horman <horms@verge.net.au>
To: Amos Waterland <apw@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, nico-kernel-nfsroot@schottelius.org
Subject: Re: [PATCH] Updates to nfsroot documentation
Message-ID: <20071204042438.GA11229@verge.net.au>
References: <20071204034345.GA30364@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071204034345.GA30364@us.ibm.com>
User-Agent: mutt-ng/devel-r804 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 10:43:45PM -0500, Amos Waterland wrote:
> The difference between ip=off and ip=::::::off has been a cause of much
> confusion.  Document how each behaves, and do not contradict ourselves
> by saying that "off" is the default when in fact "any" is the default
> and is descibed as being so lower in the file.

Is that really how it works? If so it sounds a bit silly to me.
Surely it would be desirable for ip=off and ip=::::::off to
do the same thing. Or am I missing the point?

> Signed-off-by: Amos Waterland <apw@us.ibm.com>
> 
> ---
> 
>  nfsroot.txt |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/nfsroot.txt b/Documentation/nfsroot.txt
> index 16a7cae..ac04a1d 100644
> --- a/Documentation/nfsroot.txt
> +++ b/Documentation/nfsroot.txt
> @@ -92,8 +92,11 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>
>    autoconfiguration.
>  
>    The <autoconf> parameter can appear alone as the value to the `ip'
> -  parameter (without all the ':' characters before) in which case auto-
> -  configuration is used.
> +  parameter (without all the ':' characters before).  If the value is
> +  "ip=off" or "ip=none", no autoconfiguration will take place, otherwise
> +  autoconfiguration will take place.  Note that "ip=off" is not the same
> +  thing as "ip=::::::off", because in the latter autoconfiguration will take
> +  place if any of DHCP, BOOTP or RARP are compiled in the kernel.
>  
>    <client-ip>	IP address of the client.
>  
> @@ -142,7 +145,7 @@ ip=<client-ip>:<server-ip>:<gw-ip>:<netmask>:<hostname>:<device>:<autoconf>
>  		into the kernel will be used, regardless of the value of
>  		this option.
>  
> -                  off or none: don't use autoconfiguration (default)
> +                  off or none: don't use autoconfiguration
>  		  on or any:   use any protocol available in the kernel
>  		  dhcp:        use DHCP
>  		  bootp:       use BOOTP

This second fragment seems fine, though perhaps the documentation in
net/ipv4/ipconfig.c, just above ic_proto_name, should also be updated
too.

-- 
Horms


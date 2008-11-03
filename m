Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYKCUR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYKCUR5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:17:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753974AbYKCURs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:17:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54859 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658AbYKCURr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:17:47 -0500
Date: Mon, 3 Nov 2008 12:16:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: davem@davemloft.net, johannes@sipsolutions.net, joe@perches.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/5] iscsi: bugfix for displaying IPv6 address
Message-Id: <20081103121600.b3a8eef2.akpm@linux-foundation.org>
In-Reply-To: <1225166717.5526.17.camel@brick>
References: <1225166717.5526.17.camel@brick>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Oct 2008 21:05:17 -0700
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> Notice that ip is a u8 *, so currently every other byte is
> being truncated here.
> 

I don't understand that bug description.  The code looks OK to me?

> ---
>  drivers/firmware/iscsi_ibft.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
> index 4353414..0a64720 100644
> --- a/drivers/firmware/iscsi_ibft.c
> +++ b/drivers/firmware/iscsi_ibft.c
> @@ -290,9 +290,7 @@ static ssize_t sprintf_ipaddr(char *buf, u8 *ip)
>  		/*
>  		 * IPv6
>  		 */
> -		str += sprintf(str, NIP6_FMT, ntohs(ip[0]), ntohs(ip[1]),
> -			       ntohs(ip[2]), ntohs(ip[3]), ntohs(ip[4]),
> -			       ntohs(ip[5]), ntohs(ip[6]), ntohs(ip[7]));
> +		str += sprintf(str, "%p6", ip);
>  	}
>  	str += sprintf(str, "\n");
>  	return str - buf;

Is the data format which sprintf_ipaddr() is parsing specific to iscsi?
If not, that helper function is generic and shouldn't be buried down
in drivers/firmware/iscsi_ibft.c?

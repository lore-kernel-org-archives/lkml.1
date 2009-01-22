Return-Path: <linux-kernel-owner+w=401wt.eu-S1758274AbZAVUBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274AbZAVUBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 15:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754370AbZAVUBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 15:01:34 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2123 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754248AbZAVUBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 15:01:34 -0500
Subject: Re: [PATCH] cifs: make sure we allocate enough storage for socket
 address
From: Joe Perches <joe@perches.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: smfrench@gmail.com, linux-cifs-client@lists.samba.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1232639298-9168-1-git-send-email-jlayton@redhat.com>
References: <1232639298-9168-1-git-send-email-jlayton@redhat.com>
Content-Type: text/plain
Date: Thu, 22 Jan 2009 12:00:48 -0800
Message-Id: <1232654449.15489.57.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-22 at 10:48 -0500, Jeff Layton wrote:
> The sockaddr declared on the stack in cifs_get_tcp_session is too small
> for IPv6 addresses. Change it from "struct sockaddr" to "struct
> sockaddr_storage" to prevent stack corruption when IPv6 is used.
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/cifs/connect.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index a3537a9..2209be9 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1374,11 +1374,11 @@ cifs_find_tcp_session(struct sockaddr *addr)
>  		if (server->tcpStatus == CifsNew)
>  			continue;
>  
> -		if (addr->sa_family == AF_INET &&
> +		if (addr->ss_family == AF_INET &&
>  		    (addr4->sin_addr.s_addr !=
>  		     server->addr.sockAddr.sin_addr.s_addr))
>  			continue;
> -		else if (addr->sa_family == AF_INET6 &&
> +		else if (addr->ss_family == AF_INET6 &&
>  			 memcmp(&server->addr.sockAddr6.sin6_addr,
>  				&addr6->sin6_addr, sizeof(addr6->sin6_addr)))

!ipv6_addr_equal



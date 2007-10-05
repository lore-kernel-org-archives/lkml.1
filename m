Return-Path: <linux-kernel-owner+w=401wt.eu-S1763244AbXJEQWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763244AbXJEQWU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbXJEQWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:22:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64080 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160AbXJEQWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:22:09 -0400
Date: Fri, 5 Oct 2007 09:21:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Howells <dhowells@redhat.com>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/32] Add an ERR_CAST() macro to complement ERR_PTR and
 co. [try #2]
Message-Id: <20071005092129.8fae521d.randy.dunlap@oracle.com>
In-Reply-To: <20071004155607.2814.74947.stgit@warthog.procyon.org.uk>
References: <20071004155602.2814.47731.stgit@warthog.procyon.org.uk>
	<20071004155607.2814.74947.stgit@warthog.procyon.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 04 Oct 2007 16:56:07 +0100 David Howells wrote:

> Add an ERR_CAST() macro to complement ERR_PTR and co. for the purposes of
> casting an error entyped as one pointer type to an error of another pointer
> type whilst making it explicit as to what is going on.
> 
> This provides a replacement for the ERR_PTR(PTR_ERR(p)) construct.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  include/linux/err.h |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/err.h b/include/linux/err.h
> index 1ab1d44..e810ca4 100644
> --- a/include/linux/err.h
> +++ b/include/linux/err.h
> @@ -34,6 +34,18 @@ static inline long IS_ERR(const void *ptr)
>  	return IS_ERR_VALUE((unsigned long)ptr);
>  }
>  
> +/**
> + * ERR_CAST - Explicitly cast an error-valued pointer to another pointer type
> + * ptr: The pointer to cast.

      @ptr:

> + *
> + * Explicitly cast an error-valued pointer to another pointer type in such a
> + * way as to make it clear that's what's going on.
> + */
> +static inline void *ERR_CAST(const void *ptr)
> +{
> +	return (void *) ptr;
> +}
> +
>  #endif
>  
>  #endif /* _LINUX_ERR_H */


---
~Randy

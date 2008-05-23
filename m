Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbYEWNWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbYEWNWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 09:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbYEWNUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 09:20:55 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4552 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754510AbYEWNUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 09:20:53 -0400
Date: Fri, 23 May 2008 15:13:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/21] lib: add byteorder helpers for the aligned case
Message-ID: <20080523131310.GC9245@ucw.cz>
References: <1211306721.5915.167.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211306721.5915.167.camel@brick>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-05-20 11:05:21, Harvey Harrison wrote:
> Some users know the pointer they are writeing to are aligned,
> rather than doing *(__le16 *)ptr = cpu_to_le16(val) add helpers
> wrapping this up that have the same convention as put_unaligned_le/be.
> 
> Although the get_be/le versions duplicate the le16_to_cpup functionality
> add them anyway as it makes this a complete api and start work to
> eliminate {le|be}{16|32|64}_to_cpup uses (not many).
> 
> This makes the api look like:
> 
> get_unaligned_le16
> put_unaligned_le16
> 
> get_le16
> put_le16
> 
> With explicit alignment constraints.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
>  include/linux/byteorder/generic.h |   60 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 60 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
> index 0846e6b..1f0c07e 100644
> --- a/include/linux/byteorder/generic.h
> +++ b/include/linux/byteorder/generic.h
> @@ -119,6 +119,66 @@
>  #define cpu_to_be16s __cpu_to_be16s
>  #define be16_to_cpus __be16_to_cpus
>  
> +static inline u16 get_le16(void *ptr)
> +{
> +	return le16_to_cpu(*(__le16 *)ptr);
> +}
> +

Document the fact that void * passed in needs to be 16-bit aligned?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759334AbYCNUEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbYCNUEm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYCNUEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:04:34 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33405 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbYCNUEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:04:33 -0400
Date: Fri, 14 Mar 2008 13:03:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add kerneldoc for clamp(), clamp_t(), clamp_val()
 macros
Message-Id: <20080314130306.4b134b3b.randy.dunlap@oracle.com>
In-Reply-To: <1205524734.27712.7.camel@brick>
References: <1205524734.27712.7.camel@brick>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 12:58:49 -0700 Harvey Harrison wrote:

> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks, Harvey.

> ---
>  include/linux/kernel.h |   30 ++++++++++++++++++++++++++++++
>  1 files changed, 30 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index c74460c..d57e537 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -351,6 +351,15 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
>  	(void) (&_max1 == &_max2);		\
>  	_max1 > _max2 ? _max1 : _max2; })
>  
> +/**
> + * clamp - return a value clamped to a given range with strict typechecking
> + * @val: current value
> + * @min: minimum allowable value
> + * @max: maximum allowable value
> + *
> + * This macro does strict typechecking of min/max to make sure they are of the
> + * same type as val.  See the unnecessary pointer comparisons.
> + */
>  #define clamp(val, min, max) ({			\
>  	typeof(val) __val = (val);		\
>  	typeof(min) __min = (min);		\
> @@ -376,6 +385,16 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
>  	type __max2 = (y);			\
>  	__max1 > __max2 ? __max1: __max2; })
>  
> +/**
> + * clamp_t - return a value clamped to a given range using a given type
> + * @type: the type of variable to use
> + * @val: current value
> + * @min: minimum allowable value
> + * @max: maximum allowable value
> + *
> + * This macro does no typechecking and uses temporary variables of type
> + * 'type' to make all the comparisons.
> + */
>  #define clamp_t(type, val, min, max) ({		\
>  	type __val = (val);			\
>  	type __min = (min);			\
> @@ -383,6 +402,17 @@ static inline int __attribute__ ((format (printf, 1, 2))) pr_debug(const char *
>  	__val = __val < __min ? __min: __val;	\
>  	__val > __max ? __max: __val; })
>  
> +/**
> + * clamp_val - return a value clamped to a given range using val's type
> + * @val: current value
> + * @min: minimum allowable value
> + * @max: maximum allowable value
> + *
> + * This macro does no typechecking and uses temporary variables of whatever
> + * type the input argument 'val' is.  This is useful when val is an unsigned
> + * type and min and max are literals that will otherwise be assigned a signed
> + * integer type.
> + */
>  #define clamp_val(val, min, max) ({		\
>  	typeof(val) __val = (val);		\
>  	typeof(val) __min = (min);		\
> -- 

---
~Randy

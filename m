Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYDSNZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYDSNZX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 09:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYDSNZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 09:25:08 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:48693 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754884AbYDSNZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 09:25:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAE+PCUhMROPA/2dsb2JhbACBYKk1
Date: Sat, 19 Apr 2008 09:25:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC patch 26/27] Immediate Values - Jump
Message-ID: <20080419132504.GB19416@Krystal>
References: <20080416213426.298498397@polymtl.ca> <20080416213557.859844730@polymtl.ca> <20080419203925.A900.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080419203925.A900.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:24:42 up 50 days,  9:35,  3 users,  load average: 0.38, 0.25,
	0.17
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> > Index: linux-2.6-lttng/include/linux/immediate.h
> > ===================================================================
> > --- linux-2.6-lttng.orig/include/linux/immediate.h	2008-04-16 14:04:47.000000000 -0400
> > +++ linux-2.6-lttng/include/linux/immediate.h	2008-04-16 14:04:48.000000000 -0400
> > @@ -33,8 +33,7 @@
> >   * Internal update functions.
> >   */
> >  extern void core_imv_update(void);
> > -extern void imv_update_range(const struct __imv *begin,
> > -	const struct __imv *end);
> > +extern void imv_update_range(struct __imv *begin, struct __imv *end);
> >  extern void imv_unref_core_init(void);
> >  extern void imv_unref(struct __imv *begin, struct __imv *end, void *start,
> >  		unsigned long size);
> > @@ -54,6 +53,14 @@ extern void imv_unref(struct __imv *begi
> >  #define imv_read(name)			_imv_read(name)
> >  
> >  /**
> > + * imv_cond - read immediate variable use as condition for if()
> > + * @name: immediate value name
> > + *
> > + * Reads the value of @name.
> > + */
> > +#define imv_cond			_imv_read(name)
> > +
> > +/**
> 
> err, missing name argument.
> 

Thanks, I merged it into my patchset.

Mathieu

> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> ---
>  include/linux/immediate.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/include/linux/immediate.h
> ===================================================================
> --- a/include/linux/immediate.h 2008-04-19 20:57:19.000000000 +0900
> +++ b/include/linux/immediate.h 2008-04-19 21:09:01.000000000 +0900
> @@ -62,7 +62,7 @@ struct __imv {
>   *
>   * Reads the value of @name.
>   */
> -#define imv_cond                       _imv_read(name)
> +#define imv_cond(name)                 _imv_read(name)
> 
>  /**
>   * imv_set - set immediate variable (with locking)
> 
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

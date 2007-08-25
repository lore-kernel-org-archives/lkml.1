Return-Path: <linux-kernel-owner+w=401wt.eu-S934118AbXHYSir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934118AbXHYSir (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 14:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbXHYSig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 14:38:36 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:63359 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760396AbXHYSig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 14:38:36 -0400
Date: Sat, 25 Aug 2007 14:38:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix kobject uevent string handling errors
Message-ID: <20070825183833.GA2000@Krystal>
References: <20070824224707.GA7275@Krystal> <20070824161029.6236a5f4.akpm@linux-foundation.org> <20070825001638.GB9811@Krystal> <20070824174450.70337f4f.akpm@linux-foundation.org> <20070825004640.GA21756@kroah.com> <20070825041754.GA18557@Krystal> <1188051937.2493.21.camel@lov.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1188051937.2493.21.camel@lov.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:37:52 up 26 days, 18:56,  3 users,  load average: 0.32, 0.24, 0.20
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Kay Sievers (kay.sievers@vrfy.org) wrote:
 >  	env->envp[env->envp_idx++] = &env->buf[env->buflen];
> >  	env->buflen += len + 1;
> > Index: linux-2.6-lttng/drivers/firmware/dmi-id.c
> > ===================================================================
> > --- linux-2.6-lttng.orig/drivers/firmware/dmi-id.c	2007-08-25 00:07:24.000000000 -0400
> > +++ linux-2.6-lttng/drivers/firmware/dmi-id.c	2007-08-25 00:07:58.000000000 -0400
> > @@ -152,9 +152,10 @@ static int dmi_dev_uevent(struct device 
> >  	if (add_uevent_var(env, "MODALIAS="))
> >  		return -ENOMEM;
> >  	len = get_modalias(&env->buf[env->buflen - 1],
> > -			   sizeof(env->buf) - env->buflen);
> > -	if (len >= (sizeof(env->buf) - env->buflen))
> > +			   sizeof(env->buf) - (env->buflen - 1));
> > +	if (len >= (sizeof(env->buf) - (env->buflen - 1)))
> >  		return -ENOMEM;
> > +	env->buflen += len + 1;
> 
> The increment for the trailing '\0' is already done in add_uevent_var(),
> so this change is not needed, I think.

Oh, you are right, since we replace the existing \0 which is already
accounted for, we don't have to do len +1 here.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

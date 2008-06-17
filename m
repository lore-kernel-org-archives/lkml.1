Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYFQMz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYFQMz5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 08:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756678AbYFQMzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 08:55:48 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:33073 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756261AbYFQMzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 08:55:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvIEAAdNV0hMQW1O/2dsb2JhbACBW6xT
Date: Tue, 17 Jun 2008 08:55:44 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Jens Axboe <jens.axboe@oracle.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tom Zanussi <tzanussi@gmail.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, righi.andrea@gmail.com
Subject: Re: [PATCH 2/3] relay: Fix race condition which occurs when
	reading across CPUs.
Message-ID: <20080617125543.GA8696@Krystal>
References: <20080613040958.4f52ee29@linux360.ro> <1213417601.8237.37.camel@charm-linux> <20080614181103.17617db1@linux360.ro> <20080616122249.GB18561@Krystal> <20080616162212.27a8c119@linux360.ro> <20080616164609.GM20851@kernel.dk> <84144f020806161118n70a876aeyb5ccac7b1e21d842@mail.gmail.com> <20080616182843.GS20851@kernel.dk> <20080617153934.59a7c7ee@linux360.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080617153934.59a7c7ee@linux360.ro>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:54:53 up 12 days, 17:35,  4 users,  load average: 1.00, 0.65,
	0.65
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> On Mon, 16 Jun 2008 20:28:44 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
>  
> > Hmm dunno, that is what blktrace also did but primarily for
> > performance reasons. It's tricky - Tom stated that he is working on a
> > lib to abstract this from applications. While that is handy for
> > telling you what to do, it also an annoyance that you HAVE to do it
> > that way (it's supposed to just be a "normal" fs, not with funky
> > restrictions).
> > 
> > So perhaps provide both versions in-kernel and let the kernel user
> > device. For blktrace, we have one app and we know we can use the
> > faster variant since readers are affine. For more debug style exports
> > or where you don't know your consumer, use the safer variant (which
> > should be the default action).
> 
> This sounds good. Though short debug info can be exported through
> debugfs alone, there is another use to this patch: global channels,
> which currently require kernel users to write their own locking
> mechanism.
> 
> So, are you fine with me patching relay _and blktrace_ code to use
> faster variants named relay_write_affine() and __relay_write_affine()?
> This implies having relay_write() and __relay_write() be the slower,
> safer paths. Do you agree with this names, provided the functions are
> documented correctly?
> 
> kmemtrace will use the affine versions and set CPU affinity anyway, but
> it would be nice to have a consistent behavior from relay's part.
> 

How about not changing the code, not providing a safe version of
relay_write, but document its use and what kind of locking the in-kernel
user must provide ?

Mathieu

> 
> 	Cheers,
> 	Eduard
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

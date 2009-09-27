Return-Path: <linux-kernel-owner+w=401wt.eu-S1753029AbZI0Qwy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbZI0Qwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 12:52:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbZI0Qwx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 12:52:53 -0400
Received: from fifo99.com ([67.223.236.141]:49967 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbZI0Qwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 12:52:53 -0400
Subject: Re: [PATCH] WARN_ONCE(): use bool for boolean flag
From: Daniel Walker <dwalker@fifo99.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>
In-Reply-To: <4ABF8B30.5050801@cesarb.net>
References: <1254059590-31690-1-git-send-email-cesarb@cesarb.net>
	 <1254060189.20648.462.camel@desktop>  <4ABF8B30.5050801@cesarb.net>
Content-Type: text/plain
Date: Sun, 27 Sep 2009 09:52:16 -0700
Message-Id: <1254070336.20648.518.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-27 at 12:56 -0300, Cesar Eduardo Barros wrote:
> Daniel Walker escreveu:
> > On Sun, 2009-09-27 at 10:53 -0300, Cesar Eduardo Barros wrote:
> >>  #define
> >> WARN_ON_ONCE(condition)        ({                              \
> >> -       static int __warned;                                    \
> >> +       static bool __warned;                                   \
> >>         int __ret_warn_once = !!(condition);                    \
> > 
> > Could __ret_warn_once be bool also ? It looks like just another
> > conditional variable..
> 
> Yes, it could (as long as either it is converted back to int in the 
> return of the macro, or all users do not care about the macro's return 
> type). However, the justification used for the printk_once patch (and 
> this WARN_ONCE patch) does not apply directly anymore, since the code is 
> different (to start with, it is not a static variable).

I did a couple kernel builds to test this on a small normal config,

vmlinux.base-line
   text	   data	    bss	    dec	    hex	filename
6718958	 497200	1082460	8298618	 7ea07a	vmlinux.base-line

vmlinux.one-bool <-- Your patch
   text	   data	    bss	    dec	    hex	filename
6718590	 497232	1082292	8298114	 7e9e82	vmlinux.one-bool

vmlinux.all-bool-converted 
   text	   data	    bss	    dec	    hex	filename
6718506	 497232	1082292	8298030	 7e9e2e	vmlinux.all-converted

your changes drops the size 368 bytes, and if you convert the other
conditionals it drops it by another 84 bytes. Not much more, but it's
something.

So I think Rolands original reasoning still holds.. As far as people
needing an int output from WARN_ON() , I'm not sure that's happening
anyplace .. I can't imagine a sane usage for that.. 

Daniel


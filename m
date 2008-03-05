Return-Path: <linux-kernel-owner+w=401wt.eu-S1759814AbYCEBo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814AbYCEBo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:44:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933144AbYCEBoH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:44:07 -0500
Received: from ozlabs.org ([203.10.76.45]:56812 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933594AbYCEBoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:44:05 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: PATCH [1/1]: Don't return symbol lables in init sections after they have been freed
Date: Wed, 5 Mar 2008 12:43:26 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
References: <200803041847.15884.rgetz@blackfin.uclinux.org>
In-Reply-To: <200803041847.15884.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803051243.26732.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008 10:47:15 Robin Getz wrote:
> From: Robin Getz <rgetz@blackfin.uclinux.org>
>
> Today, when module names are looked up, we do not qualify them (check to
> see if the init section is still active or not). This can lead to problems
> when kernel modules get loaded into the same address that the kernel init
> section (or other module's init section was at). We sometimes return the
> old / no lomnger there
>
> This leads to bogus OOPS messages, and developers wasting their time
> looking for problems (in the kernel init section) where there are none
> (since it was a module).

Hi Robin,

    This is a great explanation, with only one problem: it isn't true.  
mod->init_size is set to zero after init.

    Kernel submitters learn not to express doubts about their patches, lest 
they be dropped.  But it makes the job of maintainers even harder, since we 
don't know what's tested and what's an educated guess.

    As to the actual patch, your kallsyms.c patch matches 
a2da4052f1df6bc77749f84496fe731ab8b458f7's change to extable.c: please 
resubmit with just that one.  For bonus points, look at combining the extable 
and kallsyms logic so we don't diverge in future...

Thanks!
Rusty.

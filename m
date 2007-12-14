Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbXLNHZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbXLNHZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 02:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbXLNHZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 02:25:27 -0500
Received: from gw.goop.org ([64.81.55.164]:48376 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbXLNHZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 02:25:26 -0500
Message-ID: <47622FD2.2030607@goop.org>
Date: Thu, 13 Dec 2007 23:25:06 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Adrian Bunk <bunk@kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@muc.de>
Subject: Re: Print taint info in more places.
References: <20071213224927.GA18639@redhat.com> <20071214000350.GK21616@stusta.de> <20071214013041.GH22304@redhat.com>
In-Reply-To: <20071214013041.GH22304@redhat.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> On Fri, Dec 14, 2007 at 01:03:50AM +0100, Adrian Bunk wrote:
>
>  > >  #ifndef HAVE_ARCH_BUG
>  > >  #define BUG() do { \
>  > > -	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
>  > > +	printk(KERN_ERR "BUG: failure at %s:%d/%s()! (%s)\n",
>  > > +		__FILE__, __LINE__, __FUNCTION__, print_tainted()); \
>  > >  	panic("BUG!"); \
>  > >  } while (0)
>  > >  #endif
>  > >...
>  > 
>  > Note that this only changes a handful of architectures and most likely 
>  > not the ones you are interested in.
>
> Hmm, it appears that I was mistaken, and we never did patch x86.
> Which leaves me wondering if its worth it or not to  patch BUG()
> Anyways, here's the latest rev with the out-of-line changes as
> suggested by Andi.
>
> init/main.c may not be the best place for the ool variant. suggestions?
>   

lib/bug.c would be the place for architectures using
CONFIG_GENERIC_BUG.  x86 could be converted to use the BUG-trapping
mechanism for WARN_ON like Power does, so it would be inherently out of
line anyway.

    J

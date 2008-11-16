Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbYKPPWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbYKPPWA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 10:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752046AbYKPPVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 10:21:52 -0500
Received: from ns1.suse.de ([195.135.220.2]:46170 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbYKPPVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 10:21:51 -0500
Date: Sun, 16 Nov 2008 16:21:49 +0100
From: Bernhard Walle <bwalle@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       crash-utility@redhat.com
Subject: Re: [PATCH 3/3] Remove CONFIG_STRICT_DEVMEM
Message-ID: <20081116162149.07f05c7c@kopernikus.site>
In-Reply-To: <20081116150901.4d824e6d@lxorguk.ukuu.org.uk>
References: <1226846868-9595-1-git-send-email-bwalle@suse.de>
	<1226846868-9595-4-git-send-email-bwalle@suse.de>
	<20081116150901.4d824e6d@lxorguk.ukuu.org.uk>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox [2008-11-16 15:09]:
>
> > -#ifdef CONFIG_STRICT_DEVMEM
> > -
> >  int devmem_restricted = 1;
> >  
> > -#if defined(CONFIG_SYSCTL) && defined(CONFIG_STRICT_DEVMEM)
> > +#if defined(CONFIG_SYSCTL)
> >  	/*
> >  	 * since there is no unload function, we don't have to deregister that
> >  	 * the whole lifetime of the kernel and can ignore the return value
> 
> NAK - this adds a pile of memory wasting complete crap to every kernel
> including embedded systems. At least before you could turn it off now you
> can't.

For embedded users, do they use CONFIG_SYSCTL at all? If not, then we
can just allow /dev/mem access when CONFIG_SYSCTL is turned on. That
should make embedded users happy.

But: I don't want to get that patch in. I just want to have the sysctl,
if just that patch doesn't make it, well, ok for me. I just think
CONFIG_STRICT_DEVMEM is superfluous when the runtime configuration
option is present.


Regards,
Bernhard

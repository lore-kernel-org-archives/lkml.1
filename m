Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbYBMUey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbYBMUey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757819AbYBMUep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:34:45 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56444 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757842AbYBMUeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:34:44 -0500
Date: Wed, 13 Feb 2008 21:34:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Olaf Hering <olaf@aepfle.de>, linux-kernel@vger.kernel.org
Subject: Re: KVM: Export include/linux/kvm.h only if $ARCH actually supports KVM
Message-ID: <20080213203450.GB13536@uranus.ravnborg.org>
References: <20080210111525.GA28522@aepfle.de> <47B29FB5.40205@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B29FB5.40205@qumranet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 09:43:49AM +0200, Avi Kivity wrote:
> Olaf Hering wrote:
> >>Currently, make headers_check barfs due to <asm/kvm.h>, which 
> >><linux/kvm.h>
> >>includes, not existing.  Rather than add a zillion <asm/kvm.h>s, export 
> >>kvm.h
> >>only if the arch actually supports it.
> >>    
> >
> >This makes headers_install_all unreliable.
> >linux/kvm.h will not be exported, depending on what system the libc
> >headers will be generated. 
> 
> I see.  Any suggestions besides adding lots of asm-*/kvm.h?

Do not include asm/kvm.h from linux/kvm.h.
And in the few places where it is needed explicit include asm/kvm.h before
linux/kvm.h.

Alternatively inlcude asm/kvm.h inside #ifdef KERNEL"
so only userspace has to do explicit include of asm before linux variant.

	Sam

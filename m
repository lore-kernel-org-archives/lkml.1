Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbYBDUrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbYBDUrN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 15:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755968AbYBDUrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 15:47:04 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:39221 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708AbYBDUrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 15:47:01 -0500
Date: Mon, 4 Feb 2008 22:45:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080204204555.GC505@cs181133002.pp.htv.fi>
References: <20080128220944.GI8767@does.not.exist> <20080201152227.GB32085@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080201152227.GB32085@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 04:22:27PM +0100, Ingo Molnar wrote:
> 
> * Adrian Bunk <bunk@kernel.org> wrote:
> 
> >  # Select 32 or 64 bit
> >  config 64BIT
> > -	bool "64-bit kernel" if ARCH = "x86"
> > +	bool "64-bit kernel"
> >  	default ARCH = "x86_64"
> 
> NACK. You have just broken:
> 
>     make ARCH=i386 randconfig
> 
> on a 64-bit box that has a 32-bit .config in its kernel directory.
> 
> The randconfig/allyesconfig/allnoconfig variants override whatever is in 
> the current .config. Making the result depend on whatever is in the 
> .config at the moment is fundamentally wrong.
> 
> "oldconfig" on the other hand has correct sensitivity to the existing 
> .config - and that always worked correctly. So if you pop a 32-bit or a 
> 64-bit .config into a kernel tree, that will be listened to, no matter 
> whether you are on a 32-bit or on a 64-bit host.

Do you have ARCH=x86 set in your environment, the command line or 
patched into your Makefile when this works for you?

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


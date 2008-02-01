Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbYBAPW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbYBAPW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYBAPWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:22:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34314 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbYBAPWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:22:50 -0500
Date: Fri, 1 Feb 2008 16:22:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: allow 64bit setting in Kconfig
Message-ID: <20080201152227.GB32085@elte.hu>
References: <20080128220944.GI8767@does.not.exist>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128220944.GI8767@does.not.exist>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adrian Bunk <bunk@kernel.org> wrote:

>  # Select 32 or 64 bit
>  config 64BIT
> -	bool "64-bit kernel" if ARCH = "x86"
> +	bool "64-bit kernel"
>  	default ARCH = "x86_64"

NACK. You have just broken:

    make ARCH=i386 randconfig

on a 64-bit box that has a 32-bit .config in its kernel directory.

The randconfig/allyesconfig/allnoconfig variants override whatever is in 
the current .config. Making the result depend on whatever is in the 
.config at the moment is fundamentally wrong.

"oldconfig" on the other hand has correct sensitivity to the existing 
.config - and that always worked correctly. So if you pop a 32-bit or a 
64-bit .config into a kernel tree, that will be listened to, no matter 
whether you are on a 32-bit or on a 64-bit host.

	Ingo

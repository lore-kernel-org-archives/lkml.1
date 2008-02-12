Return-Path: <linux-kernel-owner+w=401wt.eu-S1762036AbYBLNEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762036AbYBLNEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbYBLNEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:04:22 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:59994 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755553AbYBLNEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:04:22 -0500
Date: Tue, 12 Feb 2008 14:04:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Thomas Petazzoni <thomas.petazzoni@enix.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Anvin" <hpa@zytor.com>,
       Matt Mackall <mpm@selenic.com>, Linux-tiny@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Configure out doublefault exception handler (Linux Tiny)
Message-ID: <20080212130428.GA32757@uranus.ravnborg.org>
References: <20080212110825.35db27cb@crazy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212110825.35db27cb@crazy>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 11:08:25AM +0100, Thomas Petazzoni wrote:
> Hi,
> 
> Enclosed patch allows to configure out the doublefault exception
> handler. The original patch of Matt Mackall added the option in
> init/Kconfig, but because this is a x86-specific thing, I thought
> arch/x86/Kconfig would be a better place. Is that correct ?
> 
> This patch applies on top on the DMI scanning code patch I've sent
> yesterday, because the DOUBLEFAULT config option is right after the DMI
> config option. Is that ok, or should I propose a patch on top of a
> vanilla 2.6.25-rc1 ?
> 
> Thanks for your review and comments,

We already have this in arch/x86/Kconfig.debug:

config DOUBLEFAULT
        default y
        bool "Enable doublefault exception handler" if EMBEDDED
        depends on X86_32
        help
          This option allows trapping of rare doublefault exceptions that
          would otherwise cause a system to silently reboot. Disabling this
          option saves about 4k and might cause you much additional grey
          hair.


It may need a small update if this is valid for both 32 and 64 bit.

	Sam

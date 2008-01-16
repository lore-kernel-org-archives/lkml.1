Return-Path: <linux-kernel-owner+w=401wt.eu-S1754250AbYAPLwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbYAPLwh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 06:52:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbYAPLw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 06:52:27 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:51417 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbYAPLw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 06:52:27 -0500
Date: Wed, 16 Jan 2008 12:52:33 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: Roman Zippel <zippel@linux-m68k.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, david-b@pacbell.net,
       linux-kernel@vger.kernel.org
Subject: Re: non-choice related config entries within choice
Message-ID: <20080116115233.GA26776@uranus.ravnborg.org>
References: <478DF61E.76E4.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478DF61E.76E4.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2008 at 11:18:38AM +0000, Jan Beulich wrote:
> Roman,
> 
> now that I finally found time to look into the problems that caused the
> patch changing boolean/tristate choice behavior to be reverted I find
> that due to the way things worked in the past there are a couple of
> cases where config options not really belonging to the choice are inside
> the choice scope (drivers/usb/gadget/Kconfig, arch/ppc/Kconfig, and
> arch/mips/Kconfig are where I found such cases, and I hope this is a
> complete list).
> 
> The question is: Is it intended for this to work the way it used to, or
> is it rather reasonable to change these scripts so that stuff dependent
> upon the choice selection is being dealt with outside the choice scope?

Hi Jan.

I will let Roman answer your question..

But one feature I really would like to see is named chocies so we can do stuff like:

choice X86_PROCESSOR

config GENERIC_PROCESSOR
	bool "A generic X86 processor"
endchoice


...

choice PPC_PROCESSOR

config GENERIC_PROCESSOR
	bool "A generic PowerPC processor

endchoice

The issue here is that we do not today allow the same config option
to appear if more than one choice.
This is a mandatory feature before we can do a Kconfig covering all architectures.
I guess there are other issues when we do:

if X86
source foo/bar/Kconfig
endif

if PPC
source foo/bar/Kconfig
endif

Where we in foo/bar/Kconfig has a choice list.

I just wanted to raise this now that you anyway are looking into choice
related issues.

	Sam

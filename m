Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYAPNqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYAPNqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 08:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752248AbYAPNqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 08:46:32 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:22625
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363AbYAPNqb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:46:31 -0500
Message-Id: <478E18E1.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 16 Jan 2008 13:46:57 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Roman Zippel" <zippel@linux-m68k.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, <david-b@pacbell.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: non-choice related config entries within choice
References: <478DF61E.76E4.0078.0@novell.com>
 <20080116115233.GA26776@uranus.ravnborg.org>
In-Reply-To: <20080116115233.GA26776@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>But one feature I really would like to see is named chocies so we can do stuff like:
>
>choice X86_PROCESSOR
>
>config GENERIC_PROCESSOR
>	bool "A generic X86 processor"
>endchoice
>
>
>...
>
>choice PPC_PROCESSOR
>
>config GENERIC_PROCESSOR
>	bool "A generic PowerPC processor
>
>endchoice
>
>The issue here is that we do not today allow the same config option
>to appear if more than one choice.

I want named choices, too, but for a different purpose (and not
unconditionally): Currently, a choice really can just be a selection
between individual boolean settings or (as the current intended
extension) a mixture of boolean and tristate values. String or
numerical values aren't permitted (and iirc they even cause the config
process to crash). Nevertheless there are a couple of example where
choosing between individual string or numeric values is intended (but
needs to be made work with the current infrastructure, meaning that
one first chooses between boolean values and then selects (or sets
through default values in prompt-less config options) the intended
string or numeric value.

What you want seems much more fundamental a change, and as I
understand it you really want the name just as a name space
separation mechanism.

>This is a mandatory feature before we can do a Kconfig covering all architectures.
>I guess there are other issues when we do:
>
>if X86
>source foo/bar/Kconfig
>endif
>
>if PPC
>source foo/bar/Kconfig
>endif
>
>Where we in foo/bar/Kconfig has a choice list.

That you be done with

if X86 || PPC
source foo/bar/Kconfig
endif

then, I would think (which should be the default anyway if you want a
Kconfig covering all architectures).

>I just wanted to raise this now that you anyway are looking into choice
>related issues.

Jan


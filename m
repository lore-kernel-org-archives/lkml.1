Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbXK1RIi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbXK1RIi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:08:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759269AbXK1RIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:08:31 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:2239 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869AbXK1RIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:08:30 -0500
Date: Wed, 28 Nov 2007 18:08:16 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Paul Mundt <lethal@linux-sh.org>
cc: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: Make KCONFIG_ALLCONFIG work with randconfig.
In-Reply-To: <20071128122011.GB29552@linux-sh.org>
Message-ID: <Pine.LNX.4.64.0711281751160.1817@scrub.home>
References: <20071128122011.GB29552@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 28 Nov 2007, Paul Mundt wrote:

> Adrian mentioned a few weeks ago that KCONFIG_ALLCONFIG is the way to
> go to ensure that things like allyes/allmod/allnoconfig work with a
> constrained set of symbols, with the implication that this holds
> true for randconfig as well.

BTW another possibility is to use all{no,mod,yes,random,}.config.

> While allyes/mod/noconfigs do seem to work fine with KCONFIG_ALLCONFIG
> provisions, randconfig tramples all over the provided values at perhaps
> not surprisingly, random.

Please be careful with such broad statements, there is only an issue with 
choice values.

> Debugging this a bit, there seemed to be two issues:
> 
> 	- SYMBOL_DEF and SYMBOL_DEF_USER overlap, which made
> 	  def_sym->flags the same regardless of whether we came from an
> 	  KCONFIG_ALLCONFIG path or not.

Look at how SYMBOL_DEF is used in confdata.c.

> 	- clobbering of the fixed value in conf_choice() by way of
> 	  random() def assignment.

Simply add a test for is_new there.

bye, Roman

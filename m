Return-Path: <linux-kernel-owner+w=401wt.eu-S965364AbXBUFVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965364AbXBUFVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 00:21:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965365AbXBUFVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 00:21:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965364AbXBUFVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 00:21:10 -0500
Date: Wed, 21 Feb 2007 00:20:57 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH] fault injection: split up stacktrace filter Kconfig option
Message-ID: <20070221052057.GB4731@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>
References: <200702210159.l1L1x9NV012176@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702210159.l1L1x9NV012176@hera.kernel.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 21, 2007 at 01:59:09AM +0000, Linux Kernel wrote:
 > Commit:     1df49008f4ddec9d4f6862b47ea5bdba82078aa4
 > Parent:     94412a96c4553255bda7a232a349059dd7543338
 > Author:     Akinobu Mita <akinobu.mita@gmail.com>
 > AuthorDate: Tue Feb 20 13:57:56 2007 -0800
 > Committer:  Linus Torvalds <torvalds@woody.linux-foundation.org>
 > CommitDate: Tue Feb 20 17:10:14 2007 -0800
 > 
 >     [PATCH] fault injection: split up stacktrace filter Kconfig option
 >     
 >     There is no prompt for CONFIG_STACKTRACE, so FAULT_INJECTION cannot be
 >     selected without LOCKDEP enabled.  (found by Paolo 'Blaisorblade'
 >     Giarrusso)
 >     
 >     In order to fix such broken Kconfig dependency, this patch splits up the
 >     stacktrace filter support for fault injection by new Kconfig option, which
 >     enables to use fault injection on the architecture which doesn't have
 >     general stacktrace support.

 ...

 > +config FAULT_INJECTION_STACKTRACE_FILTER
 > +	bool "stacktrace filter for fault-injection capabilities"
 > +	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
 > +	select STACKTRACE
 > +	select FRAME_POINTER
 > +	help
 > +	  Provide stacktrace filter for fault-injection capabilities

This help text is pretty useless. It tells the person configuring
nothing about what a stacktrace filter is, or why it might be useful.
helptexts that just parrot the name of the option might as well not be there.

		Dave

-- 
http://www.codemonkey.org.uk

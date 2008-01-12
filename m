Return-Path: <linux-kernel-owner+w=401wt.eu-S1763554AbYALN6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763554AbYALN6w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 08:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759292AbYALN6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 08:58:44 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:35670 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920AbYALN6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 08:58:43 -0500
Date: Sat, 12 Jan 2008 14:58:47 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: EGRY Gabor <gaboregry1@t-online.hu>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-kernel@zh-kernel.org
Subject: Re: [PATCH] kconfig: multibyte character support for lxdialog
Message-ID: <20080112135847.GA3580@uranus.ravnborg.org>
References: <1200139315.2785.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200139315.2785.2.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 01:01:55PM +0100, EGRY Gabor wrote:
> 
> UTF-8 support for lxdialog with wchar. The installed wide ncurses (ncursesw) is optional.

Building this on my 64 bit box with ncursesw support I saw several warnings.
Adding the following to dialog.h decreased the number:
#ifdef USE_WIDE_CURSES
#define _XOPEN_SOURCE_EXTENDED
#endif

But it was not warning free.


In addition in your patch below you assume that
ncurses wide char support and wide char support follows each other.
This assumption makes things overly complicated.

Can we assume we have wide char support everywhere today where
we will support building Linux?
I am mostly concerned about sun, cygwin and MingW here...

If we can assume wide char support everywhere your patch will
become simplerAnd adding wide char support should be a separate step.

I tried to take a look at varous source packages and they do not
need this long list of redefinitions of the ncurses functions.
Do we do something fundamentally different than for example
dialog since this indirection is needed?


	Sam

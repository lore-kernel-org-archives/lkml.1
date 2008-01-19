Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbYASXZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbYASXZn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 18:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754037AbYASXZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 18:25:33 -0500
Received: from ozlabs.org ([203.10.76.45]:42630 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbYASXZc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 18:25:32 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [lguest build regression fix] Re: 2.6.24-rc8-git1: Reported regressions from 2.6.23
Date: Sun, 20 Jan 2008 10:24:47 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <200801180035.42878.rjw@sisk.pl> <20080119180604.GA6224@elte.hu>
In-Reply-To: <20080119180604.GA6224@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801201024.47825.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 20 January 2008 05:06:04 Ingo Molnar wrote:
> x86 randconfig testing found the following build failure:
>
>  arch/x86/lguest/boot.c: In function 'lazy_hcall':
>  arch/x86/lguest/boot.c:151: error: implicit declaration of function
> 'paravirt_get_lazy_mode' arch/x86/lguest/boot.c:151: error:
> 'PARAVIRT_LAZY_NONE' undeclared (first use in this function)
>
> which i bisected down to this very fresh commit:
>
>  commit 84f7466ee20cc094aa38617abfa2f3834871f054
>  Author: Rusty Russell <rusty@rustcorp.com.au>
>  Date:   Sat Jan 19 07:02:29 2008 +1100
>
>      Selecting LGUEST should turn on Guest support, as in 2.6.23.
>
> which allows the following .config variation:
>
>  # CONFIG_PARAVIRT_GUEST is not set
>  CONFIG_LGUEST_GUEST=y

This looks like a "randconfig" bug, to be honest.

CONFIG_LGUEST_GUEST and CONFIG_LGUEST are within "if PARAVIRT_GUEST" (include 
is in arch/x86/Kconfig).

Rusty.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbYEFDoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbYEFDoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 23:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbYEFDoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 23:44:06 -0400
Received: from linux-m68k.xs4all.nl ([82.95.193.92]:50446 "EHLO
	scrub.xs4all.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752707AbYEFDoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 23:44:05 -0400
Date: Tue, 6 May 2008 05:43:32 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Adrian Bunk <bunk@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kconfig: warn about complex selects
In-Reply-To: <20080504054044.GA32030@damson>
Message-ID: <Pine.LNX.4.64.0805060511220.30555@scrub.home>
References: <20080504054044.GA32030@damson>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 4 May 2008, Vegard Nossum wrote:

> One other idea that might be feasible in terms of both correctness and
> usability: If a symbol foo does "select bar", maybe foo should simply inherit
> bar's dependencies? This allows foo to be visible in most cases (when the
> dependencies of foo and bar are both satisified), but won't brute-force-enable
> any symbols.

Well, select was introduced for exactly this purpose.

In general I don't think it's possible to warn about this without 
producing a lot a false positives. If that would discourage people from 
using select everywhere, it might be an option but I'm afraid it will only 
cause them to add even more selects just to shut up the warnings.

Here is an example patch from me just a few days ago that might qualify as 
complex select, but is quite valid:

http://marc.info/?l=linux-kernel&m=120960318111346&w=2

The problem is usually that an option which might be visible, is selected 
without all the necessary build dependencies. The question is now how do 
you want to identify options which are necessary?
In this example a simple dependency check would flag that NEW_LEDS isn't 
selected, but NEW_LEDS is a pure config dependency, i.e. it has no effect 
on the build process.

It's not an impossible problem, but it's not trivial either, so that I 
haven't spend any time on it and rather would like to spend the energy on 
fixing the problem properly instead of working around it. And the problem 
BTW isn't select itself, the problem is that all the Kconfig dependencies 
have grown and become more complex, so it's becoming increasingly more 
difficult to maintain and to use them - select was never meant to solve 
this problem...

bye, Roman

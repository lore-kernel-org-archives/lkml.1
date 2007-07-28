Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbXG1Pmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbXG1Pmq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 11:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbXG1Pmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 11:42:38 -0400
Received: from mailhost.terra.es ([213.4.149.12]:52902 "EHLO
	csmtpout4.frontal.correo" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752012AbXG1Pmh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 11:42:37 -0400
Date: Sat, 28 Jul 2007 17:42:25 +0200 (added by postmaster@terra.es)
From: grundig <grundig@teleline.es>
To: "Indan Zupancic" <indan@nul.nu>
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Al Boldi" <a1426z@gawab.com>,
       linux-kernel@vger.kernel.org
Subject: Re: swap-prefetch:  A smart way to make good use of idle resources
  (was: updatedb)
Message-Id: <20070728174022.9ae6cf9f.grundig@teleline.es>
In-Reply-To: <50998.81.207.0.53.1185580999.squirrel@secure.samage.net>
References: <200707272243.02336.a1426z@gawab.com>
	<1185568498.2711.5.camel@laptopd505.fenrus.org>
	<52449.81.207.0.53.1185573103.squirrel@secure.samage.net>
	<1185573974.2711.8.camel@laptopd505.fenrus.org>
	<20070728013251.7c110223.grundig@teleline.es>
	<50998.81.207.0.53.1185580999.squirrel@secure.samage.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

El Sat, 28 Jul 2007 02:03:19 +0200 (CEST), "Indan Zupancic" <indan@nul.nu> escribió:

> Perhaps one of the reasons is that this is core kernel code. And that it isn't a new
> feature, but a performance improvement with doubtful trade-offs. The problem
> statement isn't clear either. It seems like a natural enhancement, but is that enough
> reason to merge it? Maybe, maybe not. But if slow swap-in is the problem, shouldn't
> that be fixed instead of bypassed?


The problem AFAIK it's clear: Swap in is slow by nature because it's random. Well, it "looks"
like it should be random. Now that would be a interesting thing to analyze: locality of the
swapped-in stuff for different worloads - if the swapped-in stuff has some locality, then
it certainly should possible to fix the swapin code to do some kind of "swapahead". But if
the stuff is swapped in completely randomly, only stuff like swap prefetch is going to help.

The good thing about swap prefetch is that it fixes the problem today without forbidding
future improvements to the VM.


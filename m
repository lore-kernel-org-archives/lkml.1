Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbYCJVuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbYCJVuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 17:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbYCJVt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 17:49:58 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58829 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYCJVt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 17:49:56 -0400
Date: Mon, 10 Mar 2008 22:51:45 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephan Diestelhorst <langer_mann@web.de>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       davej@codemonkey.org.uk, cpufreq@lists.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Speedfreq-SMI call clobbers ECX
Message-ID: <20080310215145.GB9246@one.firstfloor.org>
References: <200803051559.09962.langer_mann@web.de> <200803101605.42251.langer_mann@web.de> <87iqzu8r2q.fsf@basil.nowhere.org> <200803102226.39044.langer_mann@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803102226.39044.langer_mann@web.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Please also note that these are not clobbers in the strict inline asm
> syntax, but rather dummy output values that correspond to actual

Outputs/Inputs are as bad as clobbers in triggering gcc reload ICEs.

> input parameters. I'd consider this a serious compiler flaw, if not
> bug, if these would not work. But let's not get into GCC vs.

It is, and it's (mostly) fixed in newer versions, but we're stuck with 
supporting the older compiler versions unfortunately.

> > For asms with so many clobbers explicit push/pop is usually safer.
> 
> Yes, but it is unneccessary overhead as the compiler can (should!)
> find more elegant ways to get those registers back if needed.

This code is not performance critical at all. Safer beats faster
any time in such cases.

-Andi


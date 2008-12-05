Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbYLEAIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbYLEAIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 19:08:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbYLEAIP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 19:08:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbYLEAIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 19:08:14 -0500
Date: Thu, 4 Dec 2008 16:07:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Frans Pop <elendil@planet.nl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken
 on Toshiba R500 (bisected)
In-Reply-To: <200812050045.40928.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0812041604400.3543@nehalem.linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812042340.58694.rjw@sisk.pl> <alpine.LFD.2.00.0812041459120.3543@nehalem.linux-foundation.org> <200812050045.40928.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Dec 2008, Rafael J. Wysocki wrote:
> > 
> > Yes. And in the case of Frans' machine, the e1000e controller was before 
> > all the bridges too.
> 
> Hm.  And unloading it before suspend made things work?  Interesting.

Yeah. Frans' workaround was

 - unloading e1000e before suspend
 - using aggressive powersave setting on snd_hda_intel to ensure that
   sound controller was already sleeping before entering suspend

and both of those devices are on the root PCI bus and are enumerated (and 
thus resumed) before the transparent bridge.

So yeah, the whole "resource allocation for that bridge" saga should 
_really_ not matter. But it clearly does seem to.

			Linus

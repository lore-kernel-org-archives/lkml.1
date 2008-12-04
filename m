Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbYLDIVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbYLDIVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 03:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbYLDIVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 03:21:10 -0500
Received: from hpsmtp-eml17.KPNXCHANGE.COM ([213.75.38.117]:41720 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbYLDIVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 03:21:09 -0500
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression from 2.6.26: Hibernation (possibly suspend) broken on Toshiba R500 (bisected)
Date: Thu, 4 Dec 2008 09:21:03 +0100
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Ingo Molnar <mingo@elte.hu>, jbarnes@virtuousgeek.org, lenb@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, tiwai@suse.de,
       Andrew Morton <akpm@linux-foundation.org>
References: <200812020320.31876.rjw@sisk.pl> <200812040223.54341.rjw@sisk.pl> <alpine.LFD.2.00.0812032034150.3256@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0812032034150.3256@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812040921.05945.elendil@planet.nl>
X-OriginalArrivalTime: 04 Dec 2008 08:21:06.0793 (UTC) FILETIME=[414AC590:01C955E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OOn Thursday 04 December 2008, you wrote:
> On Thu, 4 Dec 2008, Rafael J. Wysocki wrote:
> > Well, in principle it may be related to the way we handle bridges
> > during resume
>
> This is a hibernate-only issue for you, right? Or is it about regular
> suspend-to-ram too?

It is regular suspend to ram.

I feel now confident in saying that with the debug patch resume from STR 
is 100% reliable. And the two workarounds I was using to improve resume 
reliability are no longer needed:
- unloading e1000e before suspend
- using aggressive powersave setting on snd_hda_intel to ensure that
  sound controller was already sleeping before entering suspend

I don't think we have any theory yet on how those workarounds were helping 
to improve things, right?

> Well, how stable has hibernate been on that particular machine
> historically?

I cannot comment on this as I have not owned this laptop long enough.


One other thing: the ohci1394 "irq 19: nobody cared" issue is definitely 
unrelated as I just got one during a resume with the debug patch.

Cheers,
FJP

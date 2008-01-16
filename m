Return-Path: <linux-kernel-owner+w=401wt.eu-S1757935AbYAPAop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbYAPAop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYAPAoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:44:37 -0500
Received: from ns1.suse.de ([195.135.220.2]:58549 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbYAPAoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:44:37 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Date: Wed, 16 Jan 2008 01:44:32 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jan Beulich <jbeulich@novell.com>
References: <patchbomb.1200435425@localhost> <20080115223534.GA20484@elte.hu> <478D4197.8060904@goop.org>
In-Reply-To: <478D4197.8060904@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801160144.33140.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 January 2008 00:28:23 Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> > unfortunately they dont solve it:
> >
> >  [   92.042586] Freeing unused kernel memory: 328k freed
> >  [   92.091838] khelper used greatest stack depth: 6244 bytes left
> >  [   92.281738] init[1]: segfault at 00000004 ip 49471cbb sp bff8dbb0 error 4
> >  [   92.288761] init[1]: segfault at 00000004 ip 49471cbb sp bff8dbb0 error 4
> >  [   92.295763] init[1]: segfault at 00000004 ip 49471cbb sp bff8dbb0 error 4
> >  [...]
> >  [   97.312484] printk: 611046 messages suppressed.
> >
> > 32-bit, PAE and RAM above 4GB seems to be enough to trigger that bug.
> >   
> 
> Bum.  We established that once you fix the accessors+sign extension bug, 
> there's another bug somewhere later on in the series.  Any chance you 
> could move "x86/pgtable: fix constant sign extension problem" to be just 
> after "x86/pgtable: unify pagetable accessors" and bisect the following 
> patches?

Bisecting is somewhat difficult because there seem to be quite a lot of problems
in the current git-x86 stream. I found that Jan's ioremap fix also 
causes silent hangs here during earlier bisecting (not sure why) 

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758377AbYBRTTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758377AbYBRTTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbYBRTTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:19:05 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:42730 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYBRTTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:19:03 -0500
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Unable to continue testing of 2.6.25
X-Message-Flag: Warning: May contain useful information
References: <200802171025.30590.elendil@planet.nl>
	<20080217124650.576990ce@laptopd505.fenrus.org>
	<p73mypyxx6z.fsf@bingen.suse.de>
	<20080218085018.05f3190a@laptopd505.fenrus.org>
	<20080218171159.GA24090@basil.nowhere.org>
	<20080218093215.5cf611a8@laptopd505.fenrus.org>
	<adalk5ijdu1.fsf@cisco.com>
	<20080218110706.221d3015@laptopd505.fenrus.org>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 18 Feb 2008 11:18:48 -0800
In-Reply-To: <20080218110706.221d3015@laptopd505.fenrus.org> (Arjan van de Ven's message of "Mon, 18 Feb 2008 11:07:06 -0800")
Message-ID: <adahcg6jco7.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Feb 2008 19:18:48.0985 (UTC) FILETIME=[16CBE890:01C87263]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > > AFAIK mapping PCI memory WB is not allowed, so WC is really our only
 > > choice.

 > afaik that depends on the BAR being prefetchable or not.

In my case the BAR is prefetchable.

 > (and by your argument, ioremap_cached() would not be useful, and since that was, until
 > 2.6.25-rc1, the default behavior for ioremap(), would have caused massive problems)

I'm not sure what ioremap_cached() would really do in my case, since
the MTRRs for PCI memory are set to UC, so without monkeying with MTRR
contents (which can't really be done safely) the only choices we have
are leaving the mapping as UC or using PAT to get WC.

Also in my case I'm more concerned about latency of finishing a small
write rather than througput.  So I'm not sure that I would really want
to do a write to a WB mapping followed by CLFLUSH anyway.

 - R.

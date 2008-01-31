Return-Path: <linux-kernel-owner+w=401wt.eu-S1764282AbYAaDEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764282AbYAaDEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 22:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764443AbYAaDDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 22:03:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:41611 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764075AbYAaDDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 22:03:35 -0500
From: Andi Kleen <ak@suse.de>
To: Yinghai Lu <Yinghai.Lu@sun.com>
Subject: Re: PATCH] x86_64: make bootmap_start page align v4
Date: Thu, 31 Jan 2008 04:02:14 +0100
User-Agent: KMail/1.9.1
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200801291113.35974.yinghai.lu@sun.com> <200801302008.32811.ak@suse.de> <200801301215.51645.yinghai.lu@sun.com>
In-Reply-To: <200801301215.51645.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801310402.14912.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I don't think so, that is setup_node_bootmem's problem.
>
> it is supposed to round_up instead of just do PAGE_SHIFT...
>
> other caller will just use the address instead change it page.

You're right. In this case it really is the best way to round up in the 
caller. I retract my earlier objection.

That said there is not really any true requirement for the bootmem
map to be page aligned (AFAIK) so an alternative might be to 
fix the bootmem interface to not take a PFN. But that would be a 
much more intrusive patch because you would need to fix 
other architectures too or add compat wrappers.

-Andi

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755721AbYAITHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721AbYAITHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYAITHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:07:23 -0500
Received: from cantor.suse.de ([195.135.220.2]:40708 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYAITHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:07:22 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other achitectures and kill notifier cruft"
Date: Wed, 9 Jan 2008 20:07:13 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       hch@lst.de, airlied@linux.ie, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, pq@iki.fi, jbeulich@novell.com,
       linux-kernel@vger.kernel.org,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
References: <20080108192951.a4dc394f.akpm@linux-foundation.org> <20080109104149.GB8041@elte.hu> <20080109165254.GA4912@Krystal>
In-Reply-To: <20080109165254.GA4912@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801092007.13414.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Probing vmalloc faults is _really_ tricky : it also implies that the
> handler (let's call it probe) connected to the probe point (marker or
> kprobe) should _never_ cause a vmalloc page fault, 

That is why vmalloc_sync_all() was invented. It might make sense
to just call that on kprobe registration.

But I agree the other problems makes it a bad idea.

I think the better solution is to keep the notifier, but make 
it cheaper (e.g. by using constant patching ...)

-Andi

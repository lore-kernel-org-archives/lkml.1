Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbXCEOIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbXCEOIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 09:08:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752279AbXCEOIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 09:08:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39417 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbXCEOIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 09:08:06 -0500
Date: Mon, 5 Mar 2007 14:59:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Avi Kivity <avi@qumranet.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070305135918.GA32380@elte.hu>
References: <20070305120631.GA14105@elte.hu> <45EC0EB7.7080300@qumranet.com> <20070305142820.GD22829@bingen.suse.de> <20070305134854.GA31542@elte.hu> <20070305145847.GH22829@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305145847.GH22829@bingen.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <ak@suse.de> wrote:

> I think we would need to have a paravirt ops callback to decide this 
> first. But it doesn't look critical to me anyways.

well, it's critical to me in two ways: 1) to make the i386 paravirt code 
clean 2) to have a proper VDSO for a KVM paravirtual guest. The original 
change is also bad because it changes how a Linux guest behaves: it 
turns off the vdso by default, and disables the compat VDSO. I.e. it's a 
bad performance step backwards if CONFIG_PARAVIRT is enabled (uses int 
$0x80 instead of sysenter), which hurts only KVM and basically none of 
the other hypervisors. It also muddifies the VDSO picture wrt. 
virtualization.

i.e. it hurts the sane stuff and benefits the crappy stuff, and my 
change undoes that. That's enough for me to call it critical ;-)

	Ingo

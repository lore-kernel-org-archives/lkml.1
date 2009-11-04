Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZKDM1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZKDM1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755582AbZKDM1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:27:25 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58061 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755559AbZKDM1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:27:24 -0500
Date: Wed, 4 Nov 2009 13:27:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: dimm <dmitry.adamushko@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Mike Travis <travis@sgi.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>, Andreas Mohr <andi@lisas.de>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [ RFC, PATCH - 1/2, v2 ] x86-microcode: refactor microcode
	output messages
Message-ID: <20091104122716.GA11968@elte.hu>
References: <1257192496.5941.8.camel@dimm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257192496.5941.8.camel@dimm>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* dimm <dmitry.adamushko@gmail.com> wrote:

> [ resending ]
> 
> 
> Hi,
> 
> 
> this is in response to Mike's patch "Limit the number of microcode
> messages".
> 
> What's about the following (yet preliminary and not thoroughly tested)
> approach?
> 
> patch-1:
> 
> simplify 'struct ucode_cpu_info' and related functional logic.
> 
> 
> patch-2: 
> 
> reduce a number of similar 'microcode version' messages by printing a
> single message for all cpus with equal microcode version, like:
> 
> (1)
> [   96.589437] microcode: original microcode versions...
> [   96.589451] microcode: CPU0-1: sig=0x6f2, pf=0x20, revision=0x57
> 
> (2)
> [   96.603176] microcode: microcode versions after update...
> [   96.603193] microcode: CPU0-1: sig=0x6f2, pf=0x20, revision=0x57
> 
> 
> The new approach is used in microcode_init() [ i.e. when loading a
> module ] and microcode_write(), that's when we update all the cpus at
> once.
> 
> reload_for_cpu() and update-all-cpus-upon-resuming() use the old
> approach - a new microcode version is being reported upon applying it.
> 
> The latter might employ the similar 'report-for-all' approach as above
> but that would somewhat complicate the logic. Anyways, there are plenty
> of per-cpu messages upon system resuming so having some more
> update-microcode related ones won't harm that muc, I guess :-)

Seems sensible to me.

	Ingo

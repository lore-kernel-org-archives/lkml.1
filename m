Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbZALTsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbZALTsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 14:48:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753194AbZALTsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 14:48:03 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37876 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179AbZALTsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 14:48:01 -0500
Date: Mon, 12 Jan 2009 11:47:13 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
cc: Torsten Kaiser <just.for.lkml@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 fixes
In-Reply-To: <20090112192912.GA31650@linux-os.sc.intel.com>
Message-ID: <alpine.LFD.2.00.0901121145220.6528@localhost.localdomain>
References: <20090111143951.GA6666@elte.hu> <64bb37e0901110845o2561db4auf68b86d024d210a0@mail.gmail.com> <7E82351C108FA840AB1866AC776AEC4643BB73C5@orsmsx505.amr.corp.intel.com> <64bb37e0901121101y73c492fel38a70681f226b526@mail.gmail.com>
 <20090112191934.GA28851@linux-os.sc.intel.com> <20090112192912.GA31650@linux-os.sc.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Jan 2009, Pallipadi, Venkatesh wrote:
> +		if (strict_prot ||
> +		    (want_flags == _PAGE_CACHE_UC_MINUS &&
> +		     flags == _PAGE_CACHE_WB) ||
> +		    (want_flags == _PAGE_CACHE_WC &&
> +		     flags == _PAGE_CACHE_WB)) {

Please don't write code like this.

Do it as an inline function that returns true/false and has comments on 
what the hell is going on.

If a conditional doesn't fit on one line, it should generally be 
abstracted away into a readable function where the name explains what it 
does conceptually.

		Linus

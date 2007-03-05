Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXCEMlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXCEMlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 07:41:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbXCEMlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 07:41:49 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:55410 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbXCEMls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 07:41:48 -0500
Date: Mon, 5 Mar 2007 21:39:10 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Bernd Schmidt <bernds_cb1@t-online.de>
Cc: "Wu, Bryan" <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Message-ID: <20070305123910.GA13684@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Bernd Schmidt <bernds_cb1@t-online.de>,
	"Wu, Bryan" <bryan.wu@analog.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop> <20070305092346.GB11664@linux-sh.org> <45EC0DC7.8080504@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EC0DC7.8080504@t-online.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 01:32:07PM +0100, Bernd Schmidt wrote:
> Paul Mundt wrote:
> >>+comment "Memory Optimizations"
> >>+
> >>+config I_ENTRY_L1
> >>+	bool "Locate interrupt entry code in L1 Memory"
> >>+	default y
> >>+	help
> >>+	  If enabled interrupt entry code (STORE/RESTORE CONTEXT) is linked
> >>+	  into L1 instruction memory.(less latency)
> >>+
> >Wow, this is really crying out for a special linker section with slightly
> >more intelligent relocation logic. You should flag the performance
> >critical parts to be located in L1 memory directly with a section
> >attribute, rather than making everything selectable. If you overflow you
> >can simply spill in to main memory.
> 
> This is done intentionally, because it's also possible for user code to 
> be loaded into L1 memory.  We want to give users the option to avoid 
> filling it all up with kernel code.
> 
So then why not make the userspace component of it optional and allow a size
cap for kernel usage that's configurable if it's enabled? This degree of
abstraction is almost worse than no abstraction.

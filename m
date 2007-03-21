Return-Path: <linux-kernel-owner+w=401wt.eu-S934085AbXCUXqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934085AbXCUXqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933946AbXCUXqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:46:07 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:41142 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934085AbXCUXqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:46:04 -0400
Date: Thu, 22 Mar 2007 08:42:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: "Wu, Bryan" <bryan.wu@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/5] Blackfin: blackfin architecture patch update
Message-ID: <20070321234254.GA17498@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	"Wu, Bryan" <bryan.wu@analog.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <1172722480.5264.75.camel@roc-desktop> <20070305092346.GB11664@linux-sh.org> <8bd0f97a0703210844u44209fc2k27f8ccf431862557@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0703210844u44209fc2k27f8ccf431862557@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2007 at 11:44:27AM -0400, Mike Frysinger wrote:
> On 3/5/07, Paul Mundt <lethal@linux-sh.org> wrote:
> >> +int __init oprofile_arch_init(struct oprofile_operations *ops)
> >> +{
> >> +#ifdef CONFIG_HARDWARE_PM
> >[snip]
> >> +#else
> >> +     return -1;
> >> +#endif
> >> +}
> >
> >Uh.. fix your dependencies.
> 
> can you elaborate ?

This code does nothing if CONFIG_HARDWARE_PM isn't enabled, so your best
bet is to simply have an op_model_null for the cases where you can't
support the counters and work out the dependencies in the Makefile.
Trying to hack both of these together in one driver is not the way to go.

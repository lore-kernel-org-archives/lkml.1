Return-Path: <linux-kernel-owner+w=401wt.eu-S933483AbYAaQYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbYAaQYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758627AbYAaQYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:24:04 -0500
Received: from ns1.suse.de ([195.135.220.2]:36487 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757802AbYAaQYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:24:01 -0500
Date: Thu, 31 Jan 2008 17:24:00 +0100
From: Andi Kleen <ak@suse.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/9] Add an option to disable direct mapping gbpages
	and a global variable
Message-ID: <20080131162400.GB25989@bingen.suse.de>
References: <20080129606.610336873@suse.de> <20080129050635.B5A7C1B416E@basil.firstfloor.org> <alpine.LFD.1.00.0801311711130.9204@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0801311711130.9204@apollo.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 05:12:35PM +0100, Thomas Gleixner wrote:
> On Tue, 29 Jan 2008, Andi Kleen wrote:
> > +int direct_gbpages;
> > +
> > +static int __init parse_direct_gbpages(char *arg)
> > +{
> > +	if (!strcmp(arg, "off")) {
> > +		direct_gbpages = -1;
> > +		return 0;
> > +	}
> > +	return -1;
> > +}
> > +early_param("direct_gbpages", parse_direct_gbpages);
> 
> Can we please use simple boolean logic ? This 0, -1, 1 magic is more
> than confusing.

I did it this way to later allow forcing gbpages. This actually
makes sense together with debug pagealloc which right now forces
them to be off.

The only bit missing for that is a check for direct_gbpages=on

-Andi


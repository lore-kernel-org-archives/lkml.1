Return-Path: <linux-kernel-owner+w=401wt.eu-S933483AbYAaRBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbYAaRBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:01:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759560AbYAaRA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:00:59 -0500
Received: from www.tglx.de ([62.245.132.106]:42280 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758731AbYAaRA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:00:58 -0500
Date: Thu, 31 Jan 2008 18:00:33 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <ak@suse.de>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [7/9] Add an option to disable direct mapping gbpages
 and a global variable
In-Reply-To: <20080131162400.GB25989@bingen.suse.de>
Message-ID: <alpine.LFD.1.00.0801311755000.9204@apollo.tec.linutronix.de>
References: <20080129606.610336873@suse.de> <20080129050635.B5A7C1B416E@basil.firstfloor.org> <alpine.LFD.1.00.0801311711130.9204@apollo.tec.linutronix.de> <20080131162400.GB25989@bingen.suse.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, Andi Kleen wrote:

> On Thu, Jan 31, 2008 at 05:12:35PM +0100, Thomas Gleixner wrote:
> > On Tue, 29 Jan 2008, Andi Kleen wrote:
> > > +int direct_gbpages;
> > > +
> > > +static int __init parse_direct_gbpages(char *arg)
> > > +{
> > > +	if (!strcmp(arg, "off")) {
> > > +		direct_gbpages = -1;
> > > +		return 0;
> > > +	}
> > > +	return -1;
> > > +}
> > > +early_param("direct_gbpages", parse_direct_gbpages);
> > 
> > Can we please use simple boolean logic ? This 0, -1, 1 magic is more
> > than confusing.
> 
> I did it this way to later allow forcing gbpages. This actually
> makes sense together with debug pagealloc which right now forces
> them to be off.
> 
> The only bit missing for that is a check for direct_gbpages=on

Fair enough. But please use some sensible constants for
that. Otherwise it's just annoying to figure out what 0, -1, 1 and
later on 2 means.

Thanks,
	tglx

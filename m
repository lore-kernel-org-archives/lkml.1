Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYKDEHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYKDEHa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 23:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbYKDEHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 23:07:16 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:37979 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065AbYKDEHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 23:07:15 -0500
Date: Mon, 03 Nov 2008 23:07:08 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [PATCH] intel_menlo: max_state is unsigned, invalid test
In-reply-to: <20081103143526.375be238.akpm@linux-foundation.org>
X-X-Sender: lenb@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Zhang Rui <rui.zhang@intel.com>
Cc: roel kluin <roel.kluin@gmail.com>, len.brown@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Message-id: <alpine.LFD.2.00.0811032300551.3132@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <4908D067.9080207@gmail.com>
 <20081103143526.375be238.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Nov 2008, Andrew Morton wrote:

> On Wed, 29 Oct 2008 17:06:47 -0400
> roel kluin <roel.kluin@gmail.com> wrote:
> 
> > max_state is unsigned, so the test is invalid.
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> > I think max_state can only become -1, no? then probably a different
> > patch is required.
> > I may not be able to respond for a few weeks.
> > 
> > diff --git a/drivers/misc/intel_menlow.c b/drivers/misc/intel_menlow.c
> > index e00a275..980171d 100644
> > --- a/drivers/misc/intel_menlow.c
> > +++ b/drivers/misc/intel_menlow.c
> > @@ -121,7 +121,7 @@ static int memory_set_cur_bandwidth(struct thermal_cooling_device *cdev,
> >  	if (memory_get_int_max_bandwidth(cdev, &max_state))
> >  		return -EFAULT;
> >  
> > -	if (max_state < 0 || state > max_state)
> > +	if (max_state == -1 || state > max_state)
> >  		return -EINVAL;
> >  
> >  	arg_list.count = 1;
> > 
> 
> hm, maybe.
> 
> This can only happen if acpi_evaluate_integer(MEMORY_GET_BANDWIDTH)
> returned no-error and a bandwidth of zero (I assume).
> 
> Is this a special case which the driver really wanted to handle?  If
> so, why is "0" the only bad value which we're checking for?  Or is this
> all some big brainfart which should be removed?

Sujith,
Please send me a patch to intel_menlo.c that documents the
legal return values from GTHS.

If 0 is illegal, that is fine, but the upstream driver doesn't
check for it properl (I like Rui's 9/11 patch better than the above,
so andrew, you can drop this patch in any case)

thanks,
-Len

ps.  Sujith, shouldn't there be a MAINTAINERS for this driver with your 
name on it?




Return-Path: <linux-kernel-owner+w=401wt.eu-S1757713AbYFEMJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbYFEMJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 08:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbYFEMJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 08:09:07 -0400
Received: from 82-69-137-158.dsl.in-addr.zen.co.uk ([82.69.137.158]:48238 "EHLO
	uklogin.uk.level5networks.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756322AbYFEMJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 08:09:06 -0400
Date: Thu, 5 Jun 2008 13:08:30 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] cputopology: Always define CPU topology information [4th try]
Message-ID: <20080605120829.GI11300@solarflare.com>
References: <20080604154454.GD11300@solarflare.com> <20080604214715.bbebe325.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604214715.bbebe325.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 4 Jun 2008 16:44:56 +0100 Ben Hutchings <bhutchings@solarflare.com> wrote:
> 
> > Not all architectures and configurations define CPU topology information.
> > This can result in an empty topology directory in sysfs, and requires
> > in-kernel users to protect all uses with #ifdef - see
> > <http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.
> > 
> > The documentation of CPU topology specifies what the defaults should be
> > if only partial information is available from the hardware.  So we can
> > provide these defaults as a fallback.
> > 
> > This patch:
> > 
> > - Adds default definitions of the 4 topology macros to <linux/topology.h>
> > - Changes drivers/base/topology.c to use the topology macros unconditionally
> >   and to cope with definitions that aren't lvalues
> > - Updates documentation accordingly
> 
> See, this is what I meant.  After your patch we have:
[...]

Sorry, I don't know how that escaped me.  My changes to the show functions
should be unnecessary - though I think that the two different implementations
for lvalues and rvalues are a premature optimisation.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.

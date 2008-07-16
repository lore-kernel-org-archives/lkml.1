Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbYGPXLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbYGPXLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 19:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759400AbYGPXLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 19:11:06 -0400
Received: from fizeau.zen.co.uk ([212.23.8.67]:47158 "EHLO fizeau.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758627AbYGPXLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 19:11:04 -0400
X-Greylist: delayed 1101 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2008 19:11:04 EDT
Date: Wed, 16 Jul 2008 23:49:32 +0100
From: Ben Hutchings <bhutchings@solarflare.com>
To: Nathan Lynch <ntl@pobox.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] cputopology: Always define CPU topology information [4th try]
Message-ID: <20080716224931.GZ19302@solarflare.com>
References: <20080604154454.GD11300@solarflare.com> <20080716213717.GB9594@localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716213717.GB9594@localdomain>
User-Agent: Mutt/1.4.1i
X-Originating-Smarthost03-IP: [82.69.137.158]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch wrote:
> Hi Ben-
> 
> Ben Hutchings wrote:
> > Not all architectures and configurations define CPU topology information.
> > This can result in an empty topology directory in sysfs, and requires
> > in-kernel users to protect all uses with #ifdef - see
> > <http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.
> > 
> > The documentation of CPU topology specifies what the defaults should be
> > if only partial information is available from the hardware.  So we can
> > provide these defaults as a fallback.
> 
> I've been looking at adding topology information to powerpc and I came
> across this.
> 
> I understand the need for fallback definitions of the topology APIs
> within the kernel, but I'm not sure I agree with exposing these things
> in sysfs unconditionally -- the default values for physical_package_id
> and core_id don't really make sense on powerpc (and other non-x86
> architectures, I suspect).

In what way are they wrong?

> Would you object to a patch which exposes in sysfs only the topology
> information which the architecture provides?

I was primarily concerned with having the fallbacks available in-kernel.
However, I don't think you will be doing user-space any favours by
requiring checks for missing attributes for ever.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.

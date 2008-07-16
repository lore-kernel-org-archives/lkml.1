Return-Path: <linux-kernel-owner+w=401wt.eu-S1759239AbYGPVhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759239AbYGPVhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757201AbYGPVhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:37:25 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:63415 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756624AbYGPVhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:37:24 -0400
Date: Wed, 16 Jul 2008 16:37:17 -0500
From: Nathan Lynch <ntl@pobox.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH] cputopology: Always define CPU topology information [4th
 try]
Message-ID: <20080716213717.GB9594@localdomain>
References: <20080604154454.GD11300@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604154454.GD11300@solarflare.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Pobox-Relay-ID: 60554B3E-537F-11DD-939A-CE28B26B55AE-04752483!a-sasl-fastnet.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben-

Ben Hutchings wrote:
> Not all architectures and configurations define CPU topology information.
> This can result in an empty topology directory in sysfs, and requires
> in-kernel users to protect all uses with #ifdef - see
> <http://marc.info/?l=linux-netdev&m=120639033904472&w=2>.
> 
> The documentation of CPU topology specifies what the defaults should be
> if only partial information is available from the hardware.  So we can
> provide these defaults as a fallback.

I've been looking at adding topology information to powerpc and I came
across this.

I understand the need for fallback definitions of the topology APIs
within the kernel, but I'm not sure I agree with exposing these things
in sysfs unconditionally -- the default values for physical_package_id
and core_id don't really make sense on powerpc (and other non-x86
architectures, I suspect).

Would you object to a patch which exposes in sysfs only the topology
information which the architecture provides?

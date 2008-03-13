Return-Path: <linux-kernel-owner+w=401wt.eu-S1755463AbYCMMEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755463AbYCMMEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYCMMEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:04:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:39582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbYCMMEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:04:11 -0400
Subject: Re: PNP: dynamic pnp resources
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Len Brown <lenb@kernel.org>
Cc: Dave Jones <davej@codemonkey.org.uk>, linux-acpi@vger.kernel.org,
       Adam M Belay <abelay@mit.edu>, Zhao Yakui <yakui.zhao@intel.com>,
       Li Shaohua <shaohua.li@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Rene Herman <rene.herman@keyaccess.nl>
In-Reply-To: <200803121345.21297.lenb@kernel.org>
References: <20080312151452.GA4523@codemonkey.org.uk>
	 <200803121345.21297.lenb@kernel.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 13 Mar 2008 13:04:08 +0100
Message-Id: <1205409848.29877.358.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-12 at 13:45 -0400, Len Brown wrote:
> On Wednesday 12 March 2008, Dave Jones wrote:
...
> Thomas worked on a patch to make resource allocation dynamic and do away
> with these limits.  Unfortunately it was rather large and it wasn't in
> time for the 2.6.25-rc1 window.

I had the problem that I could not test on isa systems.
Rene Herman helped here a lot.
There are still open issues, last state was (comment from Rene):
------------------------
No. Please note we're talking about ISAPnP, not PnPBIOS. No BIOS
involved at all.

Driver (sound/isa/cs423x/cs4236.c) furthermore does not use anything but
the PnP layer itself. Start at snd_cs423x_pnpc_detect, which is the
pnp .probe() method.

I'll look into providing a more extensive answer and/or test whatever
comes in later.
-------------------------
I can also look at this, any hints until then are appreciated.

I also expect Bjorn was bound to other bugs and pushing things in a rush
is not good thing anyway.
At the end I asked for a macro problem I only had a rather ugly
solution, didn't get an answer (IIRC I also added a compile bug in my
suggestions) and things got stuck...

Do you want me to rework the patches, lay out where I see problems and
give it another try to get this into -mm?

I am bound to work the next days, but it shouldn't be that much work
after all anymore to summarize things and send something (not sure about
the ISA things).

Hmm, maybe someone still can give a comment on my last one, it's still valid.
I want to check every pnp_{port,mem,irq,dma}_{start,end..} whether they are valid.

This macro does not work:
+#define pnp_port_start(dev,bar)   (pnp_port_valid((dev),(bar)) ? (dev)->res.port_resource[(bar)].start \
+                                  : pnp_dbg("WARN: Port start %d - [%s] invalid - %s:%d", (bar), (dev->name), __FUNCTION__, __LINE__))

The only solution I see is to use small inline functions, but that would
blow up include/linux/pnp.h significantly. The idea of the inline
functions is stated here:
http://kerneltrap.org/mailarchive/linux-kernel/2008/2/6/743614

The warning can also be omitted (the drivers should have checked for
valid already - in theory...), but it should at least stay there at the
beginning to find drivers who do not check for valid before accessing
pnp_resource_table entries.


   Thomas




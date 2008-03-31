Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbYCaUwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbYCaUwQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 16:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754877AbYCaUwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 16:52:00 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:29869 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYCaUv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 16:51:59 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 00/37] PNP resource_table cleanups
Date: Mon, 31 Mar 2008 14:51:50 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080326171058.099442579@ldl.fc.hp.com> <200803271150.30512.bjorn.helgaas@hp.com> <47F13E13.7090608@keyaccess.nl>
In-Reply-To: <47F13E13.7090608@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803311451.54499.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 March 2008 01:40:03 pm Rene Herman wrote:
> On 27-03-08 18:50, Bjorn Helgaas wrote:
> 
> > Are any ISAPNP devices at all found?
> 
> Yes, but at most 100 * 10^4 / 2^16 percent of them. Trouble is in 04/37:
> 
> http://lkml.org/lkml/2008/3/26/273
> 
> The numeric part of the ID is a 4-digit hexadecimal value, not just decimal, 
> so '0'+ don't work. Unfortunately, that one has a few dependents, so you'll 
> probably want to restructure things yourself. If I just place the attached 
> on top, the card's found again.

Ah, right.  Thanks for tracking that down.  I forgot to factor out
isapnp_to_pnpid() and pnpid32_to_pnpid() (and acpi_ex_eisa_id_to_string()
for that matter, though that's buried in the ACPI CA)-- they're really
doing the same thing and we should only need one copy (plus the CA
one).

> Not too much avail unfortunately, as I then get a resource assignment 
> problem with your patches:
> 
> pnp: the driver 'cs4236_isapnp' has been registered
> cs4236_isapnp 01:01.00: driver attached
> cs4236_isapnp 01:01.02: driver attached
> cs4236_isapnp 01:01.03: driver attached
> cs4236_isapnp 01:01.00: unable to assign resources
> CS4236+ WSS PnP configure failed for WSS (out of resources?)
> isapnp detection failed and probing for CS4236+ is not supported
> 
> (and exact same thing for snd-es18xx) which I'll try to look at next, but 
> this ID thing will certainly need a fix first.

Hmmm...  that sounds harder.  I'll read over it again and see if I
can figure anything out.

Bjorn


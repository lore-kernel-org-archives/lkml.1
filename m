Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbYFBP4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbYFBP4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 11:56:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbYFBP4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 11:56:07 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30957 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbYFBP4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 11:56:06 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 00/15] PNP: convert resource options to unified dynamic list, v1
Date: Mon, 2 Jun 2008 09:56:07 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>
References: <20080530224853.976744229@ldl.fc.hp.com> <4842F857.9060309@keyaccess.nl>
In-Reply-To: <4842F857.9060309@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806020956.08729.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 June 2008 01:28:23 pm Rene Herman wrote:
> On 31-05-08 00:48, Bjorn Helgaas wrote:
> 
> > This patch series converts the PNP resource option structures
> > to a unified linked list.  This preserves resource order, which
> > is important for some devices.  There's more detail in the
> > comments for the last patch.
> > 
> > Any comments would be welcome.
> > 
> > This depends on some patches that are in -mm, but not yet
> > upstream.  In mmotm, these would probably go after
> > pnp-dont-sort-by-type-in-sys-resources.patch
> 
> Will look at this in more detail but as first testing feedback -- I need 
> this on top.
> 
> Both ISAPnP and PnPBIOS for some or other reason set the priority to 
> 0x100 | prio after which that 0x100 is immediately masked of again in 
> pnp_build_option() leaving just the prio. Your new scheme reserves 16 
> bits for the priority though meaning the 0x100 survives causing it to be 
> considered "invalid" by at least pnp_option_priority_name() for example.
> 
> There cannot be any currently valid reason for the 0x100 it seems given 
> that it's immediately masked of again in pnp_build_option() so let's 
> just get rid of it...

I agree, that bit looks superfluous.  I added a patch to remove it.
Thanks,
  Bjorn

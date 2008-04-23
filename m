Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868AbYDWXJJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868AbYDWXJJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 19:09:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYDWXI4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 19:08:56 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:24947 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752643AbYDWXIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 19:08:55 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 22/53] PNP: factor pnp_init_resource_table() and pnp_clean_resource_table()
Date: Wed, 23 Apr 2008 17:08:53 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080418204955.342963315@ldl.fc.hp.com> <200804211710.38660.bjorn.helgaas@hp.com> <480E5246.5000804@keyaccess.nl>
In-Reply-To: <480E5246.5000804@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804231708.53572.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2008 03:01:58 pm Rene Herman wrote:
> It seems you designed the list to be basically in any order, judging by 
> things such as pnp_new_resource which'll happily reuse resources of the 
> correct type at any position in the list. Yet, pnp_assign_foo() and friends 
> retrieve resources (through pnp_get_resource) by position in the list and 
> not by the index. I'm not overly sure of failure scenarios but isn't this 
> mixing up position and index in a bad way?

Yes, I think you're right.

My idea is that the list should end up in the same order as the
resource list from the BIOS, e.g., the _CRS and _PRS lists for
ACPI.  In the case of ISAPNP, it'll be in the order that we read
things from the hardware registers.

I think I should probably make pnp_new_resource() always allocate
a new resource and get rid of the idea of reusing something already
in the list.

> >> (do note that pnp_assign_foo are the only callers of pnp_check_foo and they 
> >> could be either merged together or at least not communicate via "idx" but 
> >> simply by passing the res/pnp_res).
> > 
> > Yes, I'd like to do that.  But I think I'd better wait or I'll never
> > get anything finished :-)
> 
> Well, the idea here was that getting rid of one "idx" here so that things 
> communicate directly removes at least one possible ordering artifact...

Yup.  I ended up doing this after all.

I updated the patches and my ACPI box with the inactive devices now
boots (it failed with the v3 patches).  I'll work on the
pnp_new_resource() thing tomorrow, but I'll send you the current
patches now in case you have a chance to try them on your ISA box.

Bjorn

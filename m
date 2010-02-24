Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454Ab0BXWiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 17:38:16 -0500
Received: from cantor.suse.de ([195.135.220.2]:35457 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758326Ab0BXWiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 17:38:15 -0500
Date: Wed, 24 Feb 2010 14:36:45 -0800
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
       kay.sievers@vrfy.org, benh@kernel.crashing.org
Subject: Re: [RFC] driver-core: Add device node pointer to struct device
Message-ID: <20100224223645.GA18883@suse.de>
References: <20100224210514.16289.86611.stgit@angua>
 <20100224214442.GB18437@suse.de>
 <fa686aa41002241409x4bcdabfet43e410eb8c480166@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fa686aa41002241409x4bcdabfet43e410eb8c480166@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 03:09:24PM -0700, Grant Likely wrote:
> On Wed, Feb 24, 2010 at 2:44 PM, Greg KH <gregkh@suse.de> wrote:
> > On Wed, Feb 24, 2010 at 02:10:30PM -0700, Grant Likely wrote:
> >> Greg and Kay,
> >>
> >> This is a patch from a larger series of OF related cleanup patches.  This
> >> one adds a new 'of_node' member to struct device, conditional upon
> >> CONFIG_OF.  The goal is to move of_node out of archdata because all
> >> arches using CONFIG_OF need it.
> >>
> >> Before I commit too much effort down this path, I want to get your
> >> feedback.  Do you have any objections to this change to struct device?
> >>
> >> @@ -414,6 +415,9 @@ struct device {
> >>                                            override */
> >>       /* arch specific additions */
> >>       struct dev_archdata     archdata;
> >> +#ifdef CONFIG_OF
> >> +     struct device_node      *of_node;
> >> +#endif
> >
> > No objection from me, but do we really need the #ifdef here?
> 
> I added the #ifdef because it is complete dead weight when CONFIG_OF
> is not set.  However, I'll defer to your preference here on what looks
> cleaner w.r.t. maintenance.

Ok, you can leave it as-is, that's not a problem.  As long as we don't
have to #ifdef the core code, it should be fine.

thanks,

greg k-h

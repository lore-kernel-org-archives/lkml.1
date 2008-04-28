Return-Path: <linux-kernel-owner+w=401wt.eu-S937903AbYD1VII@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937903AbYD1VII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 17:08:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937835AbYD1VHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 17:07:43 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:24045 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937824AbYD1VHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 17:07:42 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: [patch 50/54] ISAPNP: fold isapnp_read_resources() back into isapnp_get_resources()
Date: Mon, 28 Apr 2008 15:07:37 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Adam M Belay <abelay@mit.edu>, Li Shaohua <shaohua.li@intel.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Thomas Renninger <trenn@suse.de>, Jaroslav Kysela <perex@perex.cz>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080425183807.366134771@ldl.fc.hp.com> <20080425183934.516655076@ldl.fc.hp.com> <4813B5AB.4060308@keyaccess.nl>
In-Reply-To: <4813B5AB.4060308@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804281507.38309.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 26 April 2008 05:07:23 pm Rene Herman wrote:
> On 25-04-08 20:38, Bjorn Helgaas wrote:
> 
> > +	for (i = 0; i < ISAPNP_MAX_MEM; i++) {
> > +		ret = isapnp_read_word(ISAPNP_CFG_MEM + (i << 3)) << 8;
> > +		if (!ret)
> > +			continue;
> > +		pnp_res = pnp_add_mem_resource(dev, ret, ret, 0);
> > +		if (pnp_res)
> > +			pnp_res->index = i;
> > +	}
> > +	for (i = 0; i < ISAPNP_MAX_IRQ; i++) {
> > +		ret = (isapnp_read_word(ISAPNP_CFG_IRQ + (i << 1)) >>
> > +		     8);
> 
> Truly trivial, but if you kill the useless outer (), it fits on one line...

Fixed.  I also removed the negation, e.g., we have

    if (ret) {
        pnp_res = ...
    }

rather than

    if (!ret)
        continue;
    pnp_res = ...

Bjorn

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755974AbXJVSlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbXJVSlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:41:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbXJVSky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:40:54 -0400
Received: from gw.goop.org ([64.81.55.164]:52442 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406AbXJVSkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:40:53 -0400
Message-ID: <471CEEB4.9040807@goop.org>
Date: Mon, 22 Oct 2007 11:40:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: dean gaudet <dean@arctic.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Xen-devel <xen-devel@lists.xensource.com>, Morten@suse.de,
       David Chinner <dgc@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       =?ISO-8859-1?Q?B=F8geskov?= <xen-users@morten.bogeskov.dk>,
       xfs@oss.sgi.com, xfs-masters@oss.sgi.com,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>
Subject: Re: Interaction between Xen and XFS: stray RW mappings
References: <470FA7C3.90404@goop.org> <20071014225618.GN23367404@sgi.com>	<4712A254.4090604@goop.org>	<200710151415.07248.nickpiggin@yahoo.com.au>	<alpine.DEB.0.9999.0710212015430.2320@twinlark.arctic.org>	<471C1A61.1010001@goop.org> <p73sl439s7k.fsf@bingen.suse.de>
In-Reply-To: <p73sl439s7k.fsf@bingen.suse.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> Jeremy Fitzhardinge <jeremy@goop.org> writes:
>   
>> Yes, that's precisely the problem.  xfs does delay the unmap, leaving
>> stray mappings, which upsets Xen.
>>     
>
> Again it not just upsets Xen, keeping mappings to freed pages is wrong generally 
> and violates the x86 (and likely others like PPC) architecture because it can 
> cause illegal caching attribute aliases.
>
> The patch that went into the tree was really not correct -- this
> bogus optimization should have been unconditionally removed
> or if you really wanted an ifdef made dependent on !CONFIG_XEN &&
> !CONFIG_AGP (and likely && !CONFIG_DRM && !CONFIG_anything else that
> uses uncached mappings in memory). 
>
> You just worked around the obvious failure and leave the non obvious
> rare corruptions in, which isn't a good strategy.

Well, at least it becomes a known issue and/or placeholder for when Nick
does his grand unified vmap manager.  I guess a clean workaround would
be to add a CONFIG_XFS_LAZY_UNMAP, and do it at the Kconfig level... 
I'll cook up a patch.

    J

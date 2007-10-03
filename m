Return-Path: <linux-kernel-owner+w=401wt.eu-S1753877AbXJCEPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877AbXJCEPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 00:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbXJCEPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 00:15:25 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:59406 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbXJCEPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 00:15:25 -0400
Date: Wed, 3 Oct 2007 09:45:45 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: "Mukker, Atul" <Atul.Mukker@lsi.com>, "Moore, Eric" <Eric.Moore@lsi.com>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       balbir@in.ibm.com, Pavel Machek <pavel@ucw.cz>
Subject: Re: kdump info request
Message-ID: <20071003041545.GA5343@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <9738BCBE884FDB42801FAD8A7769C2657E2A01@NAMAIL1.ad.lsil.com> <20070919042840.GB7068@in.ibm.com> <9738BCBE884FDB42801FAD8A7769C26501B2C4DA@NAMAIL1.ad.lsil.com> <20070921041506.GB6156@in.ibm.com> <9738BCBE884FDB42801FAD8A7769C26501B2C8D3@NAMAIL1.ad.lsil.com> <20070922113553.6898978d.rdunlap@xenotime.net> <9738BCBE884FDB42801FAD8A7769C26501B7F450@NAMAIL1.ad.lsil.com> <20071001081327.d325959d.rdunlap@xenotime.net> <9738BCBE884FDB42801FAD8A7769C26501B7F4A7@NAMAIL1.ad.lsil.com> <20071001093145.7205773d.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071001093145.7205773d.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 09:31:45AM -0700, Randy Dunlap wrote:
> On Mon, 1 Oct 2007 09:35:04 -0600 Mukker, Atul wrote:
> 
> > Thanks for the information and the effort.
> > 
> > We need to support all currently shipping products with kdump support
> > available (read Red Hat and SuSE) so sooner it makes into to the
> > upstream kernel the better it is.
> > 
> > So, today there is no alternative way to find out if the driver is being
> > loaded under kdump restrictive environment?
> > 
> > Thanks
> > -Atul
> 
> I'm not the right person to answer that, but going forward, it would
> be nice to have that information and it would be good to do correctly.
> 
> I think that scanning <saved_command_line> is not actually the good/right
> way to do this.  It should just be a flag somewhere, and the flag should
> be available in all (future) kernels (and likely easily backportable
> as well, if that matters), meaning those built without kdump support.
> 
> But it's still up to the kexec developers...
> 
> 

Hi Atul/Randy,

[CCing to LKML]

Thinking more about it, looks like scanning command line is not a very good
idea.

I think we should instead look for if total available RAM in the system and
then let driver make a decision about how much memory to allocate. Pavel
already suggested it on LKML and I like the idea.

This is more generic and can be applied to kdump, kexec based hibernation and
all the future users of kexec on panic infrstrcuture which will boot a 
second kernel in restricted amount of RAM.

I am not sure what's the best way to determine the total RAM in the system
in arch independent manner. Some VM guys can tell it better. One of the ways
could be to parse /proc/iomem, the way kexec-tools does. Balbir mentioned
that traverse through the nodes and sum up present_pages. 

Any suggestions, what's the best way to determine total amount of RAM
in the system in kernel?

Right now this seems to be one odd case so this code can be inside module.
If there are more users of it then we can probably create a flag inside
kernel and export it.

Thanks
Vivek

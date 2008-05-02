Return-Path: <linux-kernel-owner+w=401wt.eu-S936527AbYEBUkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936527AbYEBUkr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 16:40:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933542AbYEBUkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 16:40:36 -0400
Received: from mga03.intel.com ([143.182.124.21]:9400 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948AbYEBUke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 16:40:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,428,1204531200"; 
   d="scan'208";a="241290900"
From: Jesse Barnes <jesse.barnes@intel.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [git head] Should X86_PAT really default to yes?
Date: Fri, 2 May 2008 13:40:24 -0700
User-Agent: KMail/1.9.9
Cc: "Frans Pop" <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Packard, Keith" <keith.packard@intel.com>
References: <200805022122.03576.elendil@planet.nl> <924EFEDD5F540B4284297C4DC59F3DEEFB8D3D@orsmsx423.amr.corp.intel.com>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEFB8D3D@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805021340.24987.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 02, 2008 12:37 pm Pallipadi, Venkatesh wrote:
> >-----Original Message-----
> >From: Frans Pop [mailto:elendil@planet.nl]
> >Sent: Friday, May 02, 2008 12:22 PM
> >To: linux-kernel@vger.kernel.org
> >Cc: Pallipadi, Venkatesh; Ingo Molnar
> >Subject: [git head] Should X86_PAT really default to yes?
> >
> >With X86_PAT enabled, when X is started I get about 40 lines
> >(with varying
> >addresses) like:
> >kernel: Xorg:3358 /dev/mem expected mapping type write-back for
> >807bf000-81000000, got uncached-minus

These messages?  They're coming from the kernel it looks like, from the 
map_devmem routine in pat.c.  I'm not sure they're accurate though; for PCI 
regions /dev/mem is *supposed* to map with UC- and not WB, so maybe this 
function needs to be updated?

> >And when X exits I get a bunch of lines like:
> >kernel: Xorg:3349 freeing invalid memtype 80020000-8002a000
> >
> >I also noticed artifacts (a band of about 2 cm high across the
> >screen) after
> >X goes to black but before the switch to VT1.

This is just a transient issue during VT switch or server exit though, right?  
X functionality isn't affected, and your VTs work fine?  If so, it might not 
be a PAT issue but just a different memory layout or something (and therefore 
it would really just be a cosmetic bug in the X driver).

I really think PAT should be on by default; if you're running into real 
functional or performance problems we'd better get them fixed rather than 
disabling PAT...

Thanks,
Jesse


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbZJBBhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbZJBBhj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932126AbZJBBhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:37:38 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:58237 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbZJBBhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:37:36 -0400
X-Greylist: delayed 553 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Oct 2009 21:37:36 EDT
Date: Thu, 1 Oct 2009 21:28:06 -0400
From: Konrad Rzeszutek <konrad@darnok.org>
To: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Cc: Jan Beulich <JBeulich@novell.com>,
       "ketuzsezr@darnok.org" <ketuzsezr@darnok.org>,
       "pjones@redhat.com" <pjones@redhat.com>,
       Martin Wilck <Martin.Wilck@fujitsu-siemens.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       alex.zeffertt@eu.citrix.com
Subject: Re: [PATCH] iSCSI/iBFT: use proper address translation
Message-ID: <20091002012806.GB27478@andromeda.dapyr.net>
References: <4AC47DED0200007800017743@vpn.id2.novell.com> <4AC5234C.5030409@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AC5234C.5030409@citrix.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 02:46:52PM -0700, Jeremy Fitzhardinge wrote:
> On 10/01/09 01:01, Jan Beulich wrote:
> > In virtual environments (namely, Xen Dom0) virt <-> phys and
> > virt <-> isa-bus translations cannot be freely interchanged. When
> > looking at memory below 1M, the latter translations should always
> > be used.
> >   
> 
> Do you have a different definition for isa_virt_to_bus in your kernel? 
> As far as I can see it is defined to be the same as virt_to_phys.  Also,
> the ISA memory is identity mapped into the domain's physical mapping
> space, so it should be directly accessible without any problems.

The issue as I've come to understand is that the virt_to_phys on
memory below the 1MB does not work. Alex suggested another fix which
ioremap's the iBFT region, but I think this patch by Martin does the same job.

Either way, it looks good to me.

Signed-off-by: Konrad Rzeszutek Wilk <ketuzsezs@darnok.org>


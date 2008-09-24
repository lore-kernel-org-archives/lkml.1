Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbYIXTSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbYIXTSf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYIXTSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:18:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:31965 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbYIXTSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ImsJ5GDDTOtCPtLsMFh53Qk/+XGkPQfJFj64UOraGd1gxFJmFhiNOx9DWlkA5Ll+8j
         gsyQ8U7rBoHLYB5tfE9ya25azVuwUDR3VGnFT8bSGfosc2m8rI64atUWHL8Ck5JQgP+H
         q9Uk0FprhrykOEKNa1ZoBI14CE8aZaKiXU6EE=
Date: Wed, 24 Sep 2008 23:18:10 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: mingo@elte.hu, macro@linux-mips.org, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] x86: apic - simplify lapic_get_maxlvt
Message-ID: <20080924191810.GB31864@localhost>
References: <20080924164618.588609232@gmail.com>> <48da6f73.0c07560a.1702.41f4@mx.google.com> <48DA8DC4.90203@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DA8DC4.90203@ct.jp.nec.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Hiroshi Shimamoto - Wed, Sep 24, 2008 at 11:58:12AM -0700]
| Cyrill Gorcunov wrote:
| > Lets use lapic_get_version helper and hide
| > register being read. Also it allow us to
| > make code a bit tighter.
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > ---
| > 
| > Index: linux-2.6.git/arch/x86/kernel/apic.c
| > ===================================================================
| > --- linux-2.6.git.orig/arch/x86/kernel/apic.c	2008-09-24 19:17:20.000000000 +0400
| > +++ linux-2.6.git/arch/x86/kernel/apic.c	2008-09-24 19:33:31.000000000 +0400
| > @@ -309,14 +309,14 @@ int get_physical_broadcast(void)
| >   */
| >  int lapic_get_maxlvt(void)
| >  {
| > -	unsigned int v;
| > +	unsigned int ver;
| >  
| > -	v = apic_read(APIC_LVR);
| > +	ver = lapic_get_version();
| >  	/*
| >  	 * - we always have APIC integrated on 64bit mode
| >  	 * - 82489DXs do not report # of LVT entries
| >  	 */
| > -	return APIC_INTEGRATED(GET_APIC_VERSION(v)) ? GET_APIC_MAXLVT(v) : 2;
| > +	return APIC_INTEGRATED(ver) ? GET_APIC_MAXLVT(ver) : 2;
|                                                       ^^^
| Hi, is this correct?
| Does ver have the full content of apic_read(APIC_LVR)?
| 
| thanks,
| Hiroshi Shimamoto
| 

Hi Hiroshi,

damn, it seems I made a mistake again!
Thanks a lot, Hiroshi! Checking now!
Somehow missed this.

		- Cyrill -

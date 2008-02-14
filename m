Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbYBMXsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbYBMXsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 18:48:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758627AbYBMXsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 18:48:05 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:38193 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757043AbYBMXsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 18:48:03 -0500
Date: Wed, 13 Feb 2008 16:07:59 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: [PATCH] SCSI: fix data corruption caused by ses
In-reply-to: <1202945127.3109.89.camel@localhost.localdomain>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       kristen.c.accardi@intel.com, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Message-id: <200802131608.00493.yinghai.lu@sun.com>
Organization: SUN
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7BIT
Content-disposition: inline
References: <200802090413.53275.yinghai.lu@sun.com>
 <200802122310.23050.yinghai.lu@sun.com>
 <1202945127.3109.89.camel@localhost.localdomain>
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008 03:25:27 pm James Bottomley wrote:
> On Tue, 2008-02-12 at 23:10 -0800, Yinghai Lu wrote:
> >  			if (type_ptr[0] != ENCLOSURE_COMPONENT_DEVICE &&
> >  			    type_ptr[0] != ENCLOSURE_COMPONENT_ARRAY_DEVICE)
> > -				continue;
> > +				goto next;
> > +
> >  			ecomp =	enclosure_component_register(edev,
> >  							     components++,
> >  							     type_ptr[0],
> >  							     name);
> > +
> > +			if (desc_ptr && !IS_ERR(ecomp) && addl_desc_ptr)
> > +				ses_process_descriptor(ecomp,
> > +						       addl_desc_ptr);
> > +		next:
> >  			if (desc_ptr) {
> >  				desc_ptr += len;
> > -				if (!IS_ERR(ecomp))
> > -					ses_process_descriptor(ecomp,
> > -							       addl_desc_ptr);
> >  
> >  				if (addl_desc_ptr)
> >  					addl_desc_ptr += addl_desc_ptr[1] + 2;
> 
> Everything looks fine, thanks, except this piece.
> 
> That 
> 
> if (x)
>      goto next;
> ...
> next:
> 
> Needs to be
> 
> if (!x) {
>    ...
> }
> 

find other problems about sub_enclosure...

will send you updated one.

YH

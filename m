Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbXK1FDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbXK1FDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 00:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbXK1FDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 00:03:33 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51782 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbXK1FDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 00:03:33 -0500
Date: Tue, 27 Nov 2007 21:02:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.24-rc3-mm1 make headers_check fails
Message-Id: <20071127210211.094e9562.akpm@linux-foundation.org>
In-Reply-To: <474405AA.2070608@qumranet.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<4743EB52.1040205@linux.vnet.ibm.com>
	<20071120163240.e54beed6.akpm@linux-foundation.org>
	<4743EF47.5000203@linux.vnet.ibm.com>
	<4743EFF8.9010307@qumranet.com>
	<20071121095821.GB1070@uranus.ravnborg.org>
	<474401BB.2020204@qumranet.com>
	<474405AA.2070608@qumranet.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2007 12:17:14 +0200 Avi Kivity <avi@qumranet.com> wrote:

> Avi Kivity wrote:
> >>>>>   
> >>>>>> The make headers_check fails,
> >>>>>>
> >>>>>>  CHECK   include/linux/usb/gadgetfs.h
> >>>>>>  CHECK   include/linux/usb/ch9.h
> >>>>>>  CHECK   include/linux/usb/cdc.h
> >>>>>>  CHECK   include/linux/usb/audio.h
> >>>>>>  CHECK   include/linux/kvm.h
> >>>>>> /root/kernels/linux-2.6.24-rc3/usr/include/linux/kvm.h requires 
> >>>>>> asm/kvm.h, which does not exist in exported headers
> >>>>>>                
> >>>>> hm, works for me, on i386 and x86_64.  What's different over there?
> >>>>>            
> >>>> Hi Andrew,
> >>>>
> >>>> It fails on the powerpc box, with allyesconfig option.
> >>>>
> >>>>  
> >>>>       
> >>> How do we fix this?  Export linux/kvm.h only on x86?  Seems ugly.
> >>>     
> >>
> >> Is kvm x86 specific? Then move the .h file to asm-x86.
> >> Otherwise no good idea...
> >>
> >>   
> >
> > kvm.h is x86 specific today, but will be s390, ppc, ia64, and x86 
> > specific tomorrow.
> >
> > What about having a asm-generic/kvm.h with a nice #error?    would 
> > that suit?
> >
> 
> headers_check continues to complain.  Is the only recourse to add 
> asm/kvm.h for all archs?
> 

That would work.

Meanwhile my recourse is to drop the kvm tree ;)

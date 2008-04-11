Return-Path: <linux-kernel-owner+w=401wt.eu-S1758907AbYDKIkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907AbYDKIkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756932AbYDKIkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:40:36 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:14932 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662AbYDKIkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IDoDhug5yf/uPET69U+rGGS2qg9EK+0Ue9S9M0cpE0v4bSoDSsWTGqip6xiSGqSifFP3thQyLgUmUiFMOGCb4taE0TmXZuYt4J5/t9ZJWqtVWGi+sXL+1Q/7EHLtxEGE+g8/+/6u1tXyRIPRyDTD0U0qiwDetyw/YjK63sTO4Bw=
Message-ID: <86802c440804110140i7752e0ayadca550cdddfd599@mail.gmail.com>
Date: Fri, 11 Apr 2008 01:40:33 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: regression caused by: genirq: do not leave interupts enabled on free_irq
Cc: "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Jeff Garzik" <jeff@garzik.org>,
       "Ayaz Abdulla" <aabdulla@nvidia.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1207899030.15605.1.camel@x61.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440804102313k4546cd73s7bffb30a14239472@mail.gmail.com>
	 <alpine.LFD.1.10.0804110841370.3261@apollo.tec.linutronix.de>
	 <86802c440804110014j44b32d16ubfaa0f327c3a384f@mail.gmail.com>
	 <86802c440804110017y62938d90x7e3e32df25a60d1@mail.gmail.com>
	 <1207899030.15605.1.camel@x61.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2008 at 12:30 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
>
>  On Fri, 2008-04-11 at 00:17 -0700, Yinghai Lu wrote:
>  > On Fri, Apr 11, 2008 at 12:14 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>  > > On Fri, Apr 11, 2008 at 12:01 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>  > >  > On Thu, 10 Apr 2008, Yinghai Lu wrote:
>  > >  >  > last week found:
>  > >  >  > after latest kernel kexec RHEL 5.1 or other stack kernel, the nvidia
>  > >  >  > forcedeth doesn't work anymore.
>  > >  >  >
>  > >  >  > I stared at forcedeth.c two days. and revert every patches about that
>  > >  >  > doesn't help.
>  > >  >
>  > >  >  So forcedeth does not come up again, when you kexec from linus.git
>  > >  >  into an older distro kernel. Or is it the other way round ?
>  > >  RHEL 5.1 kexec RHEL 5.1 : works
>  > >  RHEL 5.1 kexec linus kernel: works
>  > >  linus (after -rc2) kexec linus tree: works:
>  > >  linus  (after -rc2) kexec RHEL 5.1 : forcedeth will not come up
>  > >  linus ( before -rc2 include rc2) kexec RHEL 5.1 works
>  > >
>  > the forcedeth can not get IP address...
>
>  Sounds like you are not getting any interrupts when you receive a
>  packet.  (i.e. The interrupt line is staying disabled).
>
>  Is MSI an option here?  I'm wondering if we disable the MSI and
>  something is not enabling it.

mcp55 is using msi for forcedeth

MSI.. will look at the driver in RHEL 5.1

it seems that another server with ck804 works because it is using ioapic.

YH

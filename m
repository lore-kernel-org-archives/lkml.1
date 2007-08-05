Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbXHEEbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbXHEEbx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 00:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbXHEEbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 00:31:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:46913 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbXHEEbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 00:31:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uMo+G9ZkcPKpp2yHKLrTu/oWzXsF/J/gmCmWQ/8Z67Qc1RXwK/gRRRX5YMYIj/BDa2nvxAnyu4aH4HMw+C+yoI8y+U5gRqK6O8+wlsFj4D7kw+Q5587Yjr0bVXGU+mkO681i+Dfrbgls7QX4Xrfl9KG9tntxuNrCTWVkarfsXbE=
Message-ID: <86802c440708042131k14f676ccw8d0df0b846653f4c@mail.gmail.com>
Date: Sat, 4 Aug 2007 21:31:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: Oops in 2.6.23-rc1-git9, arch/x86_64/pci/k8-bus.c::fill_mp_bus_to_cpumask()
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Muli Ben-Yehuda" <muli@il.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, riku.seppala@kymp.net,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <200708050140.49590.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46B3A7BB.9000102@redhat.com> <200708041130.42038.ak@suse.de>
	 <20070804093222.f0d7f3c7.akpm@linux-foundation.org>
	 <200708050140.49590.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/07, Andi Kleen <ak@suse.de> wrote:
> On Saturday 04 August 2007 18:32:22 Andrew Morton wrote:
> > On Sat, 4 Aug 2007 11:30:41 +0200 Andi Kleen <ak@suse.de> wrote:
> >
> > > On Saturday 04 August 2007 00:50, Andrew Morton wrote:
> > > > On Fri, 03 Aug 2007 18:10:03 -0400
> > > >
> > > > Chuck Ebbert <cebbert@redhat.com> wrote:
> > > > > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=250859
> > > > >
> > > > > at line 74:
> > > > >
> > > > > muli@62829:
> > > > > muli@62829:                                     sd = bus->sysdata;
> > > > > muli@62829:                                     sd->node = node;   <=====
> > > > >
> > > > > bus->sysdata is NULL.
> > > > >
> > > > > Last changed by this hunk of
> > > > > "x86-64: introduce struct pci_sysdata to facilitate sharing of
> > > > > ->sysdata":
> > >
> > > Hmm, will double check. Perhaps Muli's conversion was incomplete.
> >
> > hm.
> >
> > > > > @@ -67,7 +69,9 @@ fill_mp_bus_to_cpumask(void)
> > > > >                                                 continue;
> > > > >                                         if (!node_online(node))
> > > > >                                                 node = 0;
> > > > > -                                       bus->sysdata = (void *)node;
> > > > > +
> > > > > +                                       sd = bus->sysdata;
> > > > > +                                       sd->node = node;
> > > > >                                 }
> > > > >                         }
> > > > >                 }
> > > >
> > > > Andy keeps trotting out a patch which will probably fix this,
> > >
> > > What patch do you mean? I don't have anything sysdata related
> > > left over.
> > >
> >
> > "pci device ensure sysdata initialised", now at version 4.
>
> Oh what a mess. I think I'll ask Linus to revert the sysdata patch
> instead. Clearly the stuff is half-baked
>
i noticed that you didn't sign off that patch ( from Muli). So Linus
picked it up directly?

YH

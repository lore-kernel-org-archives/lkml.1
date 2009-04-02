Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbZDBLcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbZDBLcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 07:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZDBLcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 07:32:10 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:41522 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751417AbZDBLcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 07:32:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=AaI3X+HoDxc8IkuczUp7ls5hwBVw+gDcRYJ3t2ILCUvC0jYN1IyXUcbYUlOHPa9sJG44yW64GG8F5R+7q4n3Danuu0piHC+bTmWlfAA6IAC8ky3FcmCILrUWZxn3esC3DIbGkZJj5Re3CjvN5WevV6uOeYxwXn4Vb8vbaugvXJM=  ;
X-YMail-OSG: 9pM4BN8VM1nbQIkBjx8yKY_PErlTiIcljVRbLR5z1bjL3FHwfTLPIIn3JNzhld.j9MexwrKUxL9zISFVDUMenjo2ySBiN9GEaxH9S.HEpdOTsjI.btHgiJ7C58x7P.ImWIwr5aOZ7lZAhoXJm55vF8.XQsARCUKjKaYafBjprjoDErhp3d41fB4ZWYJlxTxdmOuW7Ani6oGkvJymCKQ6b9sZPSFbpnqZOOlADwoZlDHteJpZ4IgBaFPJBHL6T9Z_hJBq2Efb85hCdnHIu3cupFVfy78fwA3x.rLqfk6FMCwyamcwQEAfR6O4mfUIj2AljJ0zX.MLGBDOlSyrIG58iNDRIvot
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [patch 0/6] Guest page hinting version 7.
Date: Thu, 2 Apr 2009 22:32:00 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       akpm@osdl.org, frankeh@watson.ibm.com, riel@redhat.com,
       hugh@veritas.com
References: <20090327150905.819861420@de.ibm.com> <200903281705.29798.rusty@rustcorp.com.au> <20090329162336.7c0700e9@skybase>
In-Reply-To: <20090329162336.7c0700e9@skybase>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904022232.02185.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 March 2009 01:23:36 Martin Schwidefsky wrote:
> On Sat, 28 Mar 2009 17:05:28 +1030
>
> Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Saturday 28 March 2009 01:39:05 Martin Schwidefsky wrote:
> > > Greetings,
> > > the circus is back in town -- another version of the guest page hinting
> > > patches. The patches differ from version 6 only in the kernel version,
> > > they apply against 2.6.29. My short sniff test showed that the code
> > > is still working as expected.
> > >
> > > To recap (you can skip this if you read the boiler plate of the last
> > > version of the patches):
> > > The main benefit for guest page hinting vs. the ballooner is that there
> > > is no need for a monitor that keeps track of the memory usage of all
> > > the guests, a complex algorithm that calculates the working set sizes
> > > and for the calls into the guest kernel to control the size of the
> > > balloons.
> >
> > I thought you weren't convinced of the concrete benefits over ballooning,
> > or am I misremembering?
>
> The performance test I have seen so far show that the benefits of
> ballooning vs. guest page hinting are about the same. I am still
> convinced that the guest page hinting is the way to go because you do
> not need an external monitor. Calculating the working set size for a
> guest is a challenge. With guest page hinting there is no need for a
> working set size calculation.

Sounds backwards to me. If the benefits are the same, then having
complexity in an external monitor (which, by the way, shares many
problems and goals of single-kernel resource/workload management),
rather than putting a huge chunk of crap in the guest kernel's core
mm code.

I still think this needs much more justification.


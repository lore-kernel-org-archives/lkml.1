Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbYEMW2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbYEMW2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 18:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbYEMW23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 18:28:29 -0400
Received: from outbound-mail-123.bluehost.com ([67.222.38.23]:38092 "HELO
	outbound-mail-123.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754124AbYEMW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 18:28:28 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] PCI: boot parameter to avoid expansion ROM memory allocation
Date: Tue, 13 May 2008 15:28:17 -0700
User-Agent: KMail/1.9.9
Cc: "Gary Hade" <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
References: <20080512205746.GB7401@us.ibm.com> <20080513210054.GB28815@us.ibm.com> <86802c440805131411w1e0c661j93ba1a1854f314d6@mail.gmail.com>
In-Reply-To: <86802c440805131411w1e0c661j93ba1a1854f314d6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805131528.18252.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  There were some lkml/linux-pci visible discussions back in
> >  November-December of last year where I floated the idea
> >  of making PCI expansion ROM memory non-assignment the default:
> >   http://marc.info/?l=linux-kernel&m=119742188215024&w=2
> >   http://marc.info/?l=linux-kernel&m=119689499508369&w=2
> >  I did not hear any objections so I went ahead and submitted
> >  the change which entered mainline at 2.6.25-rc1 but it was
> >  sternly evicted last week because of a reported regression
> >  that it had caused:
> >   http://marc.info/?l=linux-kernel&m=121029093331908&w=2
> >  Attachments to http://bugs.freedesktop.org/show_bug.cgi?id=15523
> >  indicate that a 2.6.25-rc2 x86_64 kernel was being used.
> >
> >  > can we use pci rom in 64 bit kernel?
> >
> >  Sorry, not sure if I understand this question.  I hope the
> >  above answers it.
>
> ok, i think the driver could reload fw in the option rom to reset the
> controlller in pci card.
> i don't think there is other usage for the option rom after OS loaded,
> except option rom contain other run-time code...

On graphics devices it's used for more than just POSTing (in fact POSTing is 
the least of its uses these days).  The ROM often contains tables describing 
the specific hardware configuration of a given board, including output 
information, extra supported modes, etc.

On other devices, it can be used to store default settings (this is common for 
SCSI cards iirc, though I'm not sure how much Linux drivers use this info).

> so could disable them all, and use pci-quirks to enable that for the
> device/driver need it.

Since it's probably only big systems that really need the extra address space, 
I'd rather to the opposite:  allocate ROM space by default and let a boot 
option avoid it.

Jesse

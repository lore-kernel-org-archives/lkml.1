Return-Path: <linux-kernel-owner+w=401wt.eu-S1759315AbYEMXYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315AbYEMXYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 19:24:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbYEMXX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 19:23:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:27425 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206AbYEMXX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 19:23:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GgR6PjM24ucC+Stw0LqQsRgXzzfT9tuVClIwmDLD6cDqOx9mOXrs4nkubvTXK4j91PBqWAKnYEl/Q0Vx8YCe99n+J/bebJHCl+4OZT8Cs/WHlZbiyBZ8jH+95bOaV3ngjVkB2oPcAqvdbSfMPJKkvrRAHD2ZTz66BClSM3fM7NA=
Message-ID: <86802c440805131623v4ecd038djeab9bd9937717de6@mail.gmail.com>
Date: Tue, 13 May 2008 16:23:55 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] PCI: boot parameter to avoid expansion ROM memory allocation
Cc: "Gary Hade" <garyhade@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <200805131528.18252.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080512205746.GB7401@us.ibm.com>
	 <20080513210054.GB28815@us.ibm.com>
	 <86802c440805131411w1e0c661j93ba1a1854f314d6@mail.gmail.com>
	 <200805131528.18252.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 3:28 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > >  There were some lkml/linux-pci visible discussions back in
>  > >  November-December of last year where I floated the idea
>  > >  of making PCI expansion ROM memory non-assignment the default:
>  > >   http://marc.info/?l=linux-kernel&m=119742188215024&w=2
>  > >   http://marc.info/?l=linux-kernel&m=119689499508369&w=2
>  > >  I did not hear any objections so I went ahead and submitted
>  > >  the change which entered mainline at 2.6.25-rc1 but it was
>  > >  sternly evicted last week because of a reported regression
>  > >  that it had caused:
>  > >   http://marc.info/?l=linux-kernel&m=121029093331908&w=2
>  > >  Attachments to http://bugs.freedesktop.org/show_bug.cgi?id=15523
>  > >  indicate that a 2.6.25-rc2 x86_64 kernel was being used.
>  > >
>  > >  > can we use pci rom in 64 bit kernel?
>  > >
>  > >  Sorry, not sure if I understand this question.  I hope the
>  > >  above answers it.
>  >
>  > ok, i think the driver could reload fw in the option rom to reset the
>  > controlller in pci card.
>  > i don't think there is other usage for the option rom after OS loaded,
>  > except option rom contain other run-time code...
>
>  On graphics devices it's used for more than just POSTing (in fact POSTing is
>  the least of its uses these days).  The ROM often contains tables describing
>  the specific hardware configuration of a given board, including output
>  information, extra supported modes, etc.
>
>  On other devices, it can be used to store default settings (this is common for
>  SCSI cards iirc, though I'm not sure how much Linux drivers use this info).
>
>
>  > so could disable them all, and use pci-quirks to enable that for the
>  > device/driver need it.
>
>  Since it's probably only big systems that really need the extra address space,
>  I'd rather to the opposite:  allocate ROM space by default and let a boot
>  option avoid it.

that boot option will get rid of that ROM BAR for all devices...
big system could use several graphical cards that need ROM BAR and
several cards that don't need ROM BAR.

YH

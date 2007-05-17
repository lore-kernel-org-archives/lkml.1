Return-Path: <linux-kernel-owner+w=401wt.eu-S1761439AbXEQWin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761439AbXEQWin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757258AbXEQWif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:38:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:47871 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894AbXEQWid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:38:33 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Date: Thu, 17 May 2007 18:35:48 -0400
User-Agent: KMail/1.9.5
Cc: Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
References: <20070515201914.16944e04.akpm@linux-foundation.org> <200705171517.14087.lenb@kernel.org> <20070517215203.GB7336@elf.ucw.cz>
In-Reply-To: <20070517215203.GB7336@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171835.49176.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > No, writing trip-points is neither a fix, nor it is reasonable.
> > It is a workaround at best, and it is a dangerous and mis-leading hack.
> > 
> > The OS has no capability to actually change the ACPI trip points
> > that are used by the BIOS.  Changing the OS copy of them
> > to make the user think that trip events will actually
> > happen when the temperature crosses the OS copy is crazy.
> 
> Aha... wait. It seemed to work for me when I enabled thermal
> polling...

That's exactly the point.
If you allow a user to think they over-rode a trip-point
but that trip point never fires unless they enable polling mode,
then they're not going to get what they asked for.

Yes, SuSE enables polling mode by default, but that is just
distro specific "value add" that should eventually be fixed.

> Slowing cpu down / shutdown / turn the fan on is done in the os after
> all. Should we just start polling temperatures when user writes custom
> trip points? 

I actually agree with you for passively cooled embedded systems.
Indeed, that is the topic of one of my OLS papers.

However, for an off-the-shelf laptop that the vendor ships
with a specific active and passive cooling model, Linux
is not currently set up to ignore what the vendor provided
and go off on its own.  Yes, it could be done, but for
99.99% of cases, I expect it would be a mistake.

> > If there are systems with broken thermals and the
> > ACPI thermal control needs and over-ride to turn
> > on the fan, then that is fine -- but using
> > fake trip-points and giving the user the impression
> > that they are real is not viable.
> 
> They become real when we fake _TSP, too, ..?

We are mis-using _TSP today, and over-riding it
is a hack on top of a bug...

_TSP is only supposed to be for the passive cooling
algorithm -- which by definition is polling based.
It is not intended to be used for active cooling at all.
That is what active trip were invented for...

-Len

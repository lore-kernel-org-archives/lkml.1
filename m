Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbXEQVwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbXEQVwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbXEQVwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:52:07 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39251 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755961AbXEQVwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:52:05 -0400
Date: Thu, 17 May 2007 23:52:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, len.brown@intel.com,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: 2.6.22-rc1-mm1 [cannot change thermal trip points]
Message-ID: <20070517215203.GB7336@elf.ucw.cz>
References: <20070515201914.16944e04.akpm@linux-foundation.org> <464B43BB.3070505@redhat.com> <20070517092318.GD3975@ucw.cz> <200705171517.14087.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705171517.14087.lenb@kernel.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >     ACPI: thermal trip points are read-only
> > 
> > What was the rationale? Can we get this one reverted? 
> > 
> > Some machines (HP omnibook xe3) have broken trip points -- too high --
> > so machine will overheat and trigger hw shutdown before starting
> > passive cooling.
> > 
> > That's really broken, and write to trip points is reasonable way to
> > 'fix' that. (I'd understand if you only ever let trip points to
> > decrease... but otoh root should be able to shoot himself....)
> 
> No, writing trip-points is neither a fix, nor it is reasonable.
> It is a workaround at best, and it is a dangerous and mis-leading hack.
> 
> The OS has no capability to actually change the ACPI trip points
> that are used by the BIOS.  Changing the OS copy of them
> to make the user think that trip events will actually
> happen when the temperature crosses the OS copy is crazy.

Aha... wait. It seemed to work for me when I enabled thermal
polling...

Slowing cpu down / shutdown / turn the fan on is done in the os after
all. Should we just start polling temperatures when user writes custom
trip points? 

> If there are systems with broken thermals and the
> ACPI thermal control needs and over-ride to turn
> on the fan, then that is fine -- but using
> fake trip-points and giving the user the impression
> that they are real is not viable.

They become real when we fake _TSP, too, ..?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

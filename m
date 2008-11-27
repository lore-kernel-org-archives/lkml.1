Return-Path: <linux-kernel-owner+w=401wt.eu-S1756064AbYK0N7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064AbYK0N7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 08:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYK0N6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 08:58:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57075 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbYK0N6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 08:58:46 -0500
Date: Thu, 27 Nov 2008 14:58:45 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: acpi_evaluate_integer broken by design
Message-ID: <20081127135845.GB6104@atrey.karlin.mff.cuni.cz>
References: <20081125110508.GA1943@elf.ucw.cz> <20081126132050.cecb170b.akpm@linux-foundation.org> <alpine.LFD.2.00.0811261729550.3895@localhost.localdomain> <20081126150224.947c18d4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126150224.947c18d4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Len, this looks like 2.6.28 material.  But given the poor quality of
> > > the changelog it is hard to be sure about this.  Why isn't everyone
> > > seeing these warnings?  What did Pavel do to provoke these alleged
> > > warnings?  Nobody knows...
> > 
> > I don't know know why pavel sees this and nobody else --
> > maybe something unusual he's doing with suspend?

No, playing with driver for HP LED.

Now... I guess the test confused me. Because it tests for
irqs_disabled(), I assumed it was okay to call from interrupt context,
but now I'm not sure at all. Can you help? Comment would be nice.

> If we really do need to inspect global state to handle this, it would
> be much better to create a new
> 
> bool resume_is_running_so_you_cant_sleep;
> 
> and to test that.  Something which is clear, highly specific and which
> cannot be accidentally triggered via other means.

Works for me.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

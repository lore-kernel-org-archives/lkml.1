Return-Path: <linux-kernel-owner+w=401wt.eu-S1756387AbYHMKr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbYHMKr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYHMKrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:47:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428AbYHMKrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:47:19 -0400
Date: Wed, 13 Aug 2008 03:46:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, hmh@hmh.eng.br,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       linux-stable@vger.kernel.org
Subject: Re: [PATCH] acpi: Avoid dropping rapid hotkey events (or other
 GPEs) on Asus EeePC
Message-Id: <20080813034628.0ef51866.akpm@linux-foundation.org>
In-Reply-To: <48A2B596.3050401@tuffmail.co.uk>
References: <487D23C3.5070301@student.cs.york.ac.uk>
	<487F58B6.5040309@suse.de>
	<487F6D2E.2040501@tuffmail.co.uk>
	<487F772C.1070806@suse.de>
	<487F9592.1060003@tuffmail.co.uk>
	<487F9677.4060001@suse.de>
	<20080812162854.d6907c95.akpm@linux-foundation.org>
	<48A2B596.3050401@tuffmail.co.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Aug 2008 11:21:10 +0100 Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:

> Andrew Morton wrote:
> > Did this get fixed yet?
> >
> > I have an patch in -mm which I just restored (I had to tempdrop it
> > because the acpi tree was busted for some time).  But it seems to be
> > old.
> >
> > http://bugzilla.kernel.org/show_bug.cgi?id=10919 is marked "resolved"
> > but the reporter (Maximilian) seems to think otherwise.  2.6.26.x is,
> > afaik, still unfixed, as is 2.6.27-rc.
> >   
> That's correct.  I think this specific patch should go in 2.6.27 and
> 2.6.26-stable.  No objections have been raised so far.
> 
> I still need this patch to make my brightness and volume control keys
> usable in 2.6.27-rc3.  (They auto-repeat fast enough to trigger the
> bug).  This is true even after applying the latest patches from bug
> 10919 (#25 + #27).
>

Confusing.  Please send the patch which you think we should apply.

> I think the 10919 fix makes it harder to reproduce, but it definitely
> still happens.  I guess this is because the polling-driven EC
> transactions add 1ms delays between each byte.  The slower timings leave
> a window where the buggy behaviour of my EC can make a difference.  (It
> has been seen to clear the "pending event" bit after a single event is
> read, despite having more events pending).
> 
> There are more serious consequences of this bug.  After a while it can
> confuse the EC enough to cause lockups or reboots during boot, or after
> pressing a single hotkey.  This bad state is preserved over reboots,
> even into known good kernels.  Fortunately the badness clears when power
> is removed for a long enough period.  For a while I was worried that
> something had physically burnt out.

Oh gad.  And there's no workaround?

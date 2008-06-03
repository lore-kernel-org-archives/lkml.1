Return-Path: <linux-kernel-owner+w=401wt.eu-S1758430AbYFCUIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758430AbYFCUIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbYFCUIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:08:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57157 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754819AbYFCUIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:08:06 -0400
Date: Tue, 3 Jun 2008 13:07:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nix <nix@esperi.org.uk>
Cc: dhazelton@enter.net, jdike@addtoit.com, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH 1/6] UML - Deal with host time going backwards
Message-Id: <20080603130709.fcf6a751.akpm@linux-foundation.org>
In-Reply-To: <878wxmfg99.fsf@hades.wkstn.nix>
References: <20080603190235.GA9511@c2.user-mode-linux.org>
	<20080603123211.e129c222.akpm@linux-foundation.org>
	<200806031543.56864.dhazelton@enter.net>
	<878wxmfg99.fsf@hades.wkstn.nix>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jun 2008 20:52:18 +0100
Nix <nix@esperi.org.uk> wrote:

> On 3 Jun 2008, Daniel Hazelton said:
> 
> > On Tuesday 03 June 2008 03:32:11 pm Andrew Morton wrote:
> >> On Tue, 3 Jun 2008 15:02:35 -0400
> >>
> >> Jeff Dike <jdike@addtoit.com> wrote:
> >> > Protection against the host's time going backwards - keep track of the
> >> > time at the last tick and if it's greater than the current time, keep
> >> > time stopped until the host catches up.
> >>
> >> Strange.  What would cause the host's time (or at least UML's perception
> >> of it) to go backwards?
> >
> > A wild guess would be that the UML process is running "fast" at some point and 
> > its expectation of the host's time is skewed forward because of that.
> 
> Quite so. Simply running ntp on the host (in slew-only mode, no less!) 
> can cause this.
> 
> > Another possibility is that the hosts clock got reset between the times UML 
> > has checked it and the correction was a negative one.
> 
> That too.
> 

So if I change the host's time by an hour, the time will not advance at all
on the guest for the next hour? Sounds suboptimal :)

I suppose the guest should be running an ntp client synced to something
sane anyway?

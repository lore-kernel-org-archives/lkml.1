Return-Path: <linux-kernel-owner+w=401wt.eu-S1756422AbZBTXxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422AbZBTXxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 18:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbZBTXxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 18:53:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754179AbZBTXxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 18:53:13 -0500
Date: Fri, 20 Feb 2009 15:53:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.29-rc5
Message-Id: <20090220155309.d73b403c.akpm@linux-foundation.org>
In-Reply-To: <1235173256.9025.47.camel@localhost.localdomain>
References: <1235170927.9025.42.camel@localhost.localdomain>
	<20090220152305.8a2e384f.akpm@linux-foundation.org>
	<1235173256.9025.47.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Feb 2009 23:40:56 +0000
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Fri, 2009-02-20 at 15:23 -0800, Andrew Morton wrote:
> > On Fri, 20 Feb 2009 17:02:07 -0600
> > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
>
> ...
>
> > Did the mpt-fusion MSI problems get sorted out?  I think so...
> 
> Yes, but in the PCI tree.

OK, fingers crossed for Jesse.

> > I believe that "scsi: mpt: suppress debugobjects warning" is 2.6.29
> > material.  Sent 11 Feb, no response.
> 
> This is http://bugzilla.kernel.org/show_bug.cgi?id=12662 which is
> reported fixed with no code changes.

I think the followup is bogus.  

drivers/message/fusion/mptbase.c:GetLanConfigPages() calls mpt_config()
against an on-stack CONFIGPARMS, which embeds an on-stack timer_list.

So we should still use init_timer_on_stack().  Hopefully that won't
explode if mpt_config() is called with a CONFIGPARMS which _isn't_ on
the stack.

argh, I'll ping Thomas again.

> > Also I believe that "hptiop: add new PCI device ID" should be in 2.6.29
> > (and earlier), below.  I can send this on if you like.
> 
> I have this marked for inclusion, I'm just sending out the fixes that
> have been incubating in next prior to reconstructing a new fixes tree.

ok, thanks.

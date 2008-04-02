Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbYDBOg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbYDBOg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754912AbYDBOgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:36:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812AbYDBOgU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:36:20 -0400
Subject: Re: [PATCH 0/3] xen: Fix oops when mapping/unmapping addr above 1Gb
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <47F0FB5F.2000908@goop.org>
References: <1206722297-11763-1-git-send-email-markmc@redhat.com>
	 <20080331131442.GF14636@elte.hu>  <47F0FB5F.2000908@goop.org>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 15:35:43 +0100
Message-Id: <1207146943.11911.1.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-31 at 07:55 -0700, Jeremy Fitzhardinge wrote:
> Ingo Molnar wrote:
> > * Mark McLoughlin <markmc@redhat.com> wrote:
> >   
> >>         In Fedora rawhide we're currently seeing oopses whenever a 
> >> processes dlopen()s a library which prelink() has previously relocated 
> >> above 1Gb. Some more details at:
> >>
> >>   https://bugzilla.redhat.com/436453
> >>
> >>         The issue seems to be that during xen_pgd_pin(), we only pin 
> >> PTE pages, but xen's release_pmd() tries to unpin PMD pages too.
> >>
> >>         The following series of patches is against the latest x86 
> >> tree.
> >>     
> >
> > thanks, i've picked them up to get them tested - but it would be nice to 
> > have an ack from Jeremy as well. This seems like v2.6.25 material as 
> > well, right?
> 
> Didn't I reply?  Anyway, the patch looks good.  It's definitely 2.6.25 
> material; its fallout from the changes I did to dynamically 
> allocate/deallocate pmds rather than always do them with the pgd.

Okay, here are the patches rebased to 2.6.25-rc8.

I've reproduced the issue with plain -rc8 and confirmed the patches fix
it.

Cheers,
Mark.


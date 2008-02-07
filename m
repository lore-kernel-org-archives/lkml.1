Return-Path: <linux-kernel-owner+w=401wt.eu-S1763174AbYBGXD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763174AbYBGXD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 18:03:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbYBGXDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 18:03:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46495 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756946AbYBGXDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 18:03:44 -0500
Date: Thu, 7 Feb 2008 15:03:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: - typhoon-section-fix.patch removed from -mm tree
Message-Id: <20080207150332.ecf6b756.akpm@linux-foundation.org>
In-Reply-To: <20080207223601.GB23004@uranus.ravnborg.org>
References: <200802072230.m17MU87x025986@imap1.linux-foundation.org>
	<20080207223601.GB23004@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008 23:36:01 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> On Thu, Feb 07, 2008 at 02:30:08PM -0800, akpm@linux-foundation.org wrote:
> > 
> > The patch titled
> >      typhoon section fix
> > has been removed from the -mm tree.  Its filename was
> >      typhoon-section-fix.patch
> > 
> > This patch was dropped because I just remembered __devexitconst :(
> 
> But powerpc is subtle and I foresee that we have to kill __devinitconst
> and friends soonish.
> The problem is that despite data being const the compiler does not
> always mark the section const.
> So we will see a lot of the errors you see for powerpc now
> that we unconditionally specify a section.
> 
> Previously this inconsistentcy were hidden by the fact that powerpc tagets
> seldom were build without CONFIG_HOTPLUG=y.
> 
> So the patches are correct.
> Tomorrow I hope to do a patch that kill __devinitconst :-(
> 

hrm, OK.

> >  
> > -static const char version[] __devinitdata =
> > +static char version[] __devinitdata =
> >      "typhoon.c: version " DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
> >  

but chances are that in a year's time someone will come along and helpfully
make this const again.  Maybe we should annotate such sites with

#define cant_make_me_const_ask_sam_why /**/

to avoid this..

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760700AbXGEMmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760700AbXGEMmu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 08:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbXGEMmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 08:42:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53321 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756842AbXGEMmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 08:42:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mackerras <paulus@samba.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 14:49:54 +0200
User-Agent: KMail/1.9.5
Cc: Miklos Szeredi <miklos@szeredi.hu>, stern@rowland.harvard.edu,
       oliver@neukum.org, mjg59@srcf.ucam.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0707041139100.25704-100000@netrider.rowland.org> <E1I6ATN-0007QS-00@dorka.pomaz.szeredi.hu> <18060.16064.519060.755991@cargo.ozlabs.ibm.com>
In-Reply-To: <18060.16064.519060.755991@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051449.55004.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 02:43, Paul Mackerras wrote:
> Miklos Szeredi writes:
> 
> > OK, let me summarize the situation as I see it now: there are two
> > camps, the pro-freezers and the anti-freezers.
> > 
> > Pro-freezers say:
> > 
> >   - don't remove the freezer, otherwise we'll have to deal with
> >     numerous problems in drivers
> > 
> > Anti-freezers say:
> > 
> >   - let's remove the freezer, which causes numerous problems
> > 
> > Alan summerized the pro-freezer arguments well I think.  What are the
> > anti-freezer arguments then?
> 
> 1. The freezer cannot be guaranteed deadlock-free without constructing
>    a dependency graph between tasks (both user and kernel), which is
>    virtually impossible since the dependencies are not externally
>    observable.

I don't agree with that.

The freezer only fails to handle uninterruptible tasks, so we need to take
the situations in which an uninterruptible task waits for a frozen task into
consideration.  Now, if both tasks are from the user land, this is highly
unusual.

> 2. As a consequence of (1), we try to make a crude approximation of
>    the graph by saying "only kernel threads that want to be frozen
>    will be frozen" or some other similar statement.

No.  The rule is that kernel threads should not be freezable, but there are
some for which that is useful.

> 3. However, (2) means that we can no longer guarantee that drivers
>    will not get any I/O requests after their suspend method has been
>    called, and therefore the freezer fails in its main objective.

This is a very general statement.  Can you please give some examples?

> 4. We have an existence proof that reliable suspend can be achieved
>    without the freezer.

No.  We only know that it might work if the nonboot CPUs are disabled before
suspending devices, which is not the case in the generic suspend code.

> To summarize, the argument is that the freezer is deadlock-prone and
> ineffective.

I remain unconvinced. ;-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth

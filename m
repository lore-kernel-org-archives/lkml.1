Return-Path: <linux-kernel-owner+w=401wt.eu-S1756612AbZBEMUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612AbZBEMUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 07:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZBEMT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 07:19:56 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42303 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbZBEMT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 07:19:56 -0500
Date: Thu, 5 Feb 2009 13:19:54 +0100
From: Pavel Machek <pavel@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, rusty@rustcorp.com.au, travis@sgi.com,
       mingo@redhat.com, davej@redhat.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-ID: <20090205121954.GA10468@atrey.karlin.mff.cuni.cz>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com> <200902041314.32277.rusty@rustcorp.com.au> <20090203190111.2ec31cef.akpm@linux-foundation.org> <200902042111.35543.rusty@rustcorp.com.au> <20090204073636.30f15339.akpm@linux-foundation.org> <20090204213519.GR22608@elte.hu> <20090204134823.8eefa728.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090204134823.8eefa728.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 4 Feb 2009 22:35:19 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> > > mm/pdflush.c:
> > > 
> > >   wtf what the heck is all that stuff and who added it?  weird.
> > > 
> > >   Leave it alone I guess.  Can admins manually move kernel threads to
> > >   other CPUs?
> > 
> > they can - and there's even tools that do that (there's some -rt tools where 
> > you can put kernel thread priorities into a config file).
> > 
> 
> Oh well, DontDoThatThen.
> 
> I expect that the same argument applies to most of the set_cpus_allowed()
> callsites - they're run by root-only code.  Sure, root can (with
> careful timing) move root's own thread onto the wrong CPU in the middle
> of microcode loading.  In which case root gets to own both pieces.

Actually... with selinux and similar extensions, being root should not
mean you can run arbitrary code at the kernel level....


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

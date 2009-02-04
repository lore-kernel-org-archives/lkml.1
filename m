Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbZBDVtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbZBDVtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbZBDVsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:48:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48385 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752780AbZBDVsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:48:54 -0500
Date: Wed, 4 Feb 2009 13:48:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: rusty@rustcorp.com.au, travis@sgi.com, mingo@redhat.com, davej@redhat.com,
       cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] work_on_cpu: Use our own workqueue.
Message-Id: <20090204134823.8eefa728.akpm@linux-foundation.org>
In-Reply-To: <20090204213519.GR22608@elte.hu>
References: <20090116191108.135927000@polaris-admin.engr.sgi.com>
	<200902041314.32277.rusty@rustcorp.com.au>
	<20090203190111.2ec31cef.akpm@linux-foundation.org>
	<200902042111.35543.rusty@rustcorp.com.au>
	<20090204073636.30f15339.akpm@linux-foundation.org>
	<20090204213519.GR22608@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 22:35:19 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > mm/pdflush.c:
> > 
> >   wtf what the heck is all that stuff and who added it?  weird.
> > 
> >   Leave it alone I guess.  Can admins manually move kernel threads to
> >   other CPUs?
> 
> they can - and there's even tools that do that (there's some -rt tools where 
> you can put kernel thread priorities into a config file).
> 

Oh well, DontDoThatThen.

I expect that the same argument applies to most of the set_cpus_allowed()
callsites - they're run by root-only code.  Sure, root can (with
careful timing) move root's own thread onto the wrong CPU in the middle
of microcode loading.  In which case root gets to own both pieces.

We only really need to worry about the places where non-root code can
run set_cpus_allowed().  And then we only need to worry a little bit.

Yes?

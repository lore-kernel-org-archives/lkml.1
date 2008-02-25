Return-Path: <linux-kernel-owner+w=401wt.eu-S1759553AbYBYXku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759553AbYBYXku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:40:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbYBYXkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:40:41 -0500
Received: from charybdis-ext.suse.de ([195.135.221.2]:39434 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755807AbYBYXkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:40:40 -0500
Subject: Re: [(RT RFC) PATCH v2 2/9] sysctl for runtime-control of lateral
	mutex stealing
From: Sven-Thorsten Dietrich <sdietrich@novell.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       bill.huey@gmail.com, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, ak@suse.de, acme@redhat.com, gregkh@suse.de,
       pmorreale@novell.com, mkohari@novell.com
In-Reply-To: <20080225230011.GQ2659@elf.ucw.cz>
References: <20080225155959.11268.35541.stgit@novell1.haskins.net>
	 <20080225160048.11268.55059.stgit@novell1.haskins.net>
	 <20080225215335.GE2659@elf.ucw.cz>
	 <1203980231.16711.115.camel@sven.thebigcorporation.com>
	 <20080225230011.GQ2659@elf.ucw.cz>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 15:40:26 -0800
Message-Id: <1203982826.16711.161.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-26 at 00:00 +0100, Pavel Machek wrote:
> Hi!
> 
> > > > index c913d48..c24c53d 100644
> > > > --- a/kernel/sysctl.c
> > > > +++ b/kernel/sysctl.c
> > > > @@ -175,6 +175,10 @@ extern struct ctl_table inotify_table[];
> > > >  int sysctl_legacy_va_layout;
> > > >  #endif
> > > >  
> > > > +#ifdef CONFIG_RTLOCK_LATERAL_STEAL
> > > > +extern int rtmutex_lateral_steal;
> > > > +#endif
> > > > +
> > > 
> > > Try checkpatch.
> > 
> > I have that as part of quilt refresh, and it returns:
> > 
> > Your patch has no obvious style problems and is ready for
> > submission.
> 
> Sorry. Anyway, there should not be externs in .c files, so 
> 
> extern int rtmutex_lateral_steal;
> 
> should go to header file.

Just for the record:

grep extern kernel/sysctl.c | wc -l
40

There is a whole slew here, that I agree could move elsewhere - maybe
into sysctl.h?

If no one objects, I'll make a patch to move them all?

Sven

> 									Pavel


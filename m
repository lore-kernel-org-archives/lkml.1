Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZA0Iod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZA0Iod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 03:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZA0IoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 03:44:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:2278 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbZA0IoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 03:44:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nyfwo9+duTVrHePeJNON2Wrowwn+h/2gUPcxjnD7t2gkFrYw/eGul8peyMBKTO8tAm
         wgKcNTFfpJsHSHOrEYrsLXQ/KkOm4hlmcSNOoWat5Aufzn5msFGLBEJFyQ7awfoyEFZA
         Levna1iztBzmNtwleePS/9M/ezhMMeD342wfU=
Date: Tue, 27 Jan 2009 11:49:56 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kyle McMartin <kyle@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Bartelmus <lirc@bartelmus.de>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] export get_task_comm()
Message-ID: <20090127084956.GA8416@x200.localdomain>
References: <20090120071641.B0A3.KOSAKI.MOTOHIRO@jp.fujitsu.com> <AuEeLWHZjFB@christoph> <20090128140615.D464.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20090126211655.c7287768.akpm@linux-foundation.org> <20090127051919.GA5034@bombadil.infradead.org> <20090126212615.2658b29e.akpm@linux-foundation.org> <20090126212918.d4770115.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090126212918.d4770115.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 09:29:18PM -0800, Andrew Morton wrote:
> On Mon, 26 Jan 2009 21:26:15 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 27 Jan 2009 00:19:19 -0500 Kyle McMartin <kyle@infradead.org> wrote:
> > 
> > > On Mon, Jan 26, 2009 at 09:16:55PM -0800, Andrew Morton wrote:
> > > > Ho hum, I suppose so.  I redid the changelog a bit:
> > > > 
> > > >    task_struct.comm[] is useful for debugging and driver developers
> > > >    want to use this information easily.  Direct access to
> > > >    task_struct.comm[] is a bit racy, so export the official accessor.
> > > > 
> > > 
> > > Maybe lirc should be submitted to staging/ before we go exporting
> > > symbols for out of tree things... ;-)
> > 
> > y:/usr/src/linux-2.6.29-rc2> grep -r 'current->comm' drivers | wc -l
> > 77
> > 
> > :(
> 
> It's worth a checkpatch rule, I guess: "direct access to
> task_struct.comm is racy - use get_task_comm()".

And majority of usages is some debugging printk where nobody cares if ->comm
corrupted.

Changelog says is useful for debugging. That's right, tsk->comm is useful
for debugging, not allocating temporary buffer + get_task_comm().

Some ->comm usages are for kernel threads which never change it, for starters.

current->comm is always safe, because, current is not executing prctl(2)! 

I'd say nothing should be done and, heavens forbid, adding this to checkpatch.pl.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756763AbYAIVae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763AbYAIVae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbYAIVa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:30:26 -0500
Received: from one.firstfloor.org ([213.235.205.2]:49101 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616AbYAIVa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:30:26 -0500
Date: Wed, 9 Jan 2008 22:32:58 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: andi@firstfloor.org, harvey.harrison@gmail.com, jdike@addtoit.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: uml and -regparm=3
Message-ID: <20080109213258.GC15612@one.firstfloor.org>
References: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu> <p734pdmput0.fsf@bingen.suse.de> <E1JCiLx-0006lI-HR@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1JCiLx-0006lI-HR@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 10:20:49PM +0100, Miklos Szeredi wrote:
> > Miklos Szeredi <miklos@szeredi.hu> writes:
> > 
> > > FASTCALL is defined empty in -mm, but UML is not compiled with
> > > -mregparm=3 and so this breaks things (I noticed problems with
> > > rwsem_down_write_failed).
> > >
> > > Tried recompiling UML with -mregparm=3, but that resulted in a strange
> > > failure immediately after startup:
> > >
> > > |%G�%@: Invalid argument
> > >
> > > What's up?
> > 
> > UML links with glibc and that does not use -mregparm. 
> > 
> > You can only use -mregparm in user space if you recompile
> > all libraries too.
> 
> Ah, right.  I didn't think of that.
> 
> Does that mean that FASTCALL removals will have to be undone?  Or is
> there an alternative?

FASTCALL is useless and should not make a difference. It enables
regparm on specific functions, but that should not make a difference
if it works or not.

For working -mregparm you will need asmlinkage on all
functions that interface with assembler code to disable regparms for them.
The only exception is system calls which have the arguments on the stack
too.

-Andi

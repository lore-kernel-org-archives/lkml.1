Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYAIVd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYAIVd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 16:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbYAIVdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 16:33:50 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:33234 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbYAIVdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 16:33:50 -0500
Date: Wed, 9 Jan 2008 23:33:06 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: andi@firstfloor.org, harvey.harrison@gmail.com, jdike@addtoit.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: uml and -regparm=3
Message-ID: <20080109213305.GC4394@does.not.exist>
References: <E1JCi3M-0006hO-7i@pomaz-ex.szeredi.hu> <p734pdmput0.fsf@bingen.suse.de> <E1JCiLx-0006lI-HR@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1JCiLx-0006lI-HR@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-12-11)
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
> > > |%Gï¿½%@: Invalid argument
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

It's enough when we keep fastcall/FASTCALL in the few cases where UML 
calls assembler code with this calling convention. [1]

> Miklos

cu
Adrian

[1] http://lkml.org/lkml/2007/12/4/425

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbYF0EVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbYF0EVW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 00:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbYF0EVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 00:21:07 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:58694 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751787AbYF0EVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 00:21:05 -0400
X-Sasl-enc: 7+7sXXGP92nuaJAWpzvjoZ8ES+HhUYDxwzMgVeBq08a2 1214540463
Subject: Re: Linux 2.6.26-rc4
From: Ian Kent <raven@themaw.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, miklos@szeredi.hu,
       jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, jmoyer@redhat.com
In-Reply-To: <20080605153019.77d61199.akpm@linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>
	 <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>
	 <20080603095713.GR28946@ZenIV.linux.org.uk>
	 <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>
	 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>
	 <20080603104035.GT28946@ZenIV.linux.org.uk>
	 <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>
	 <20080603105258.GV28946@ZenIV.linux.org.uk>
	 <1212499623.3025.46.camel@raven.themaw.net>
	 <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
	 <1212651099.3047.44.camel@raven.themaw.net>
	 <20080605153019.77d61199.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 27 Jun 2008 12:18:19 +0800
Message-Id: <1214540300.3084.12.camel@raven.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-06-05 at 15:30 -0700, Andrew Morton wrote:
> >  
> > +	ino->u.symlink = cp;
> > +	ino->size = strlen(symname);
> >  	dir->i_mtime = CURRENT_TIME;
> 
> This all seems a bit ungainly.  I assume that on entry to
> autofs4_dir_symlink(), ino->size is equal to strlen(symname)?  If it's
> not, that strcpy() will overrun.
> 
> But if ino->size _is_ equal to strlen(symname) then why did we just
> recalculate the same thing?

Oops.
I've fixed that in my git tree just now.

> 
> I'm suspecting we can zap a lump of code and just do
> 
> 	cp = kstrdup(symname, GFP_KERNEL);
> 
> Anyway, please check that.

Yep, but fix now re-factor later.

Ian



Return-Path: <linux-kernel-owner+w=401wt.eu-S933908AbXHOQ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908AbXHOQ7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 12:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761161AbXHOQ6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 12:58:53 -0400
Received: from smtpout.mac.com ([17.250.248.186]:52314 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757749AbXHOQ6w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 12:58:52 -0400
In-Reply-To: <16329.19717.qm@web52501.mail.re2.yahoo.com>
References: <16329.19717.qm@web52501.mail.re2.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <08054D5B-FDC2-4A79-8599-E135432E9B45@mac.com>
Cc: Michael Tharp <gxti@partiallystapled.com>, alan <alan@clueserver.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Thinking outside the box on file systems
Date: Wed, 15 Aug 2007 12:58:39 -0400
To: Marc Perkel <mperkel@yahoo.com>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 15, 2007, at 12:02:41, Marc Perkel wrote:
> Kyle, thinking further outside the box, files would no longer have  
> owners or permissions. Nor would
> directories. People, groups, managers, and other  objects with have  
> permissions. One might tag a file with the object that created it  
> so you could implement "self" rights which might be use to replace  
> the concept of /tmp directories.

Well, that's actually kind of close to how SELinux works.

This is the real fundamental design gotcha:
   Our current apps *AND* admins speak "UNIX" and "POSIX".  They  
don't speak "MarcPerkelOS" (or even "SELinux").  As long as there is  
not a reasonably-close-to-1-to-1 mapping between UNIX semantics and  
your "outside the box" semantics, the latter can't really be used.   
It would just involve rewriting too much code *AND* retraining too  
many admins from scratch to make it work.  Hell, even Windows and Mac  
have moved towards a UNIX-like permissions system, precisely because  
it's a simple model which is relatively easy to teach people how to  
use.  ACLs are just a slight modification of that model to allow two  
things:
   (A) Additional user/group permissions
   (B) Default permissions for new child files/dirs/etc

People are having a huge problem with SELinux permissions as is, and  
portions of that are a fairly standard model that's been worked over  
in various OSes for many years.  I seriously doubt that anything that  
far "outside the box" is going to be feasible, at least in the near  
term.

Good new filesystem developments are likely to be ones which preserve  
the same outer model, yet allow for deeper/more-powerful control for  
those users/admins who need it.

Cheers,
Kyle Moffett


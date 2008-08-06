Return-Path: <linux-kernel-owner+w=401wt.eu-S1763558AbYHFLfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763558AbYHFLfI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 07:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759529AbYHFLa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 07:30:27 -0400
Received: from pmx1.sophos.com ([213.31.172.16]:58105 "EHLO pmx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759512AbYHFLa0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 07:30:26 -0400
In-Reply-To: <200808062110.58764.nickpiggin@yahoo.com.au>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux interface for	on
 access scanning
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
From: tvrtko.ursulin@sophos.com
Date: Wed, 6 Aug 2008 12:29:34 +0100
X-MIMETrack: S/MIME Sign by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 12:30:22,
	Serialize by Notes Client on Tvrtko Ursulin/Dev/UK/Sophos(Release 7.0.2|September
 26, 2006) at 06/08/2008 12:30:22,
	Serialize complete at 06/08/2008 12:30:22,
	S/MIME Sign failed at 06/08/2008 12:30:22: The cryptographic key was not
 found,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 06/08/2008 12:29:36,
	Serialize complete at 06/08/2008 12:29:36
Content-Type: text/plain; charset="US-ASCII"
Message-Id: <20080806113028.35CD831682F@pmx1.sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote on 06/08/2008 12:10:58:

> On Wednesday 06 August 2008 19:44, tvrtko.ursulin@sophos.com wrote:
> > Nick Piggin wrote on 05/08/2008 19:08:05:
> > > On Tuesday 05 August 2008 07:00, Eric Paris wrote:
> > > > 5. Define which filesystems are cacheable and which are not
> > >
> > > This is practically impossible to do completely without rewriting a 
lot
> > > of code (which will never be accepted). I don't see why it is needed
> >
> > though
> >
> > > as the filesystem cache is supposed to be kept coherent with disk.
> >
> > Problem is with network filesystems. So could it be a flag somewhere 
per
> > filesystem which would say something like "this filesystem guarantees
> > content of a file cannot change without get_write_access or
> > file_update_time being called locally"? That doesn't sound like a lot 
of
> > code so what am I missing?
> 
> Maybe... but that's not the same as what requirement 5 calls for.

I see what you mean, it should have been worded better. Nevertheless that 
is what was intended by it - to enable caching only on filesystems where 
it is safe to do so.
 
> But depending on exactly what semantics you really call for, it can get
> tricky to account for all of pagecache. Writes can happen through page
> tables or get_user_pages. True that a process has to at some point have
> write permission to the file, but the cache itself could be modified
> even after the file is closed and all mmaps disappear.

I don't have a very good understanding of the VM subsystem I must admit. 
So in other words with the current kernel file modification time is not 
necessarily correct - it represents when the file was last opened for 
modification, not when it was actually modified? (While those two points 
in time can be arbitrarily separated)

How would I use those methods for file modification? I am curious to make 
a test case..

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon,
OX14 3YP, United Kingdom.

Company Reg No 2096520. VAT Reg No GB 348 3873 20.


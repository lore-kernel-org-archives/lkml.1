Return-Path: <linux-kernel-owner+w=401wt.eu-S1756080AbYCSTeG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbYCSTeG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:34:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYCST1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:27:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57532 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753015AbYCSTYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:24:47 -0400
Date: Wed, 19 Mar 2008 02:04:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Message-Id: <20080319020440.80379d50.akpm@linux-foundation.org>
In-Reply-To: <20080319083228.GM11966@one.firstfloor.org>
References: <20080318209.039112899@firstfloor.org>
	<20080318003620.d84efb95.akpm@linux-foundation.org>
	<20080318141828.GD11966@one.firstfloor.org>
	<20080318095715.27120788.akpm@linux-foundation.org>
	<20080318172045.GI11966@one.firstfloor.org>
	<20080318104437.966c10ec.akpm@linux-foundation.org>
	<20080319083228.GM11966@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Mar 2008 09:32:28 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> On Tue, Mar 18, 2008 at 10:44:37AM -0700, Andrew Morton wrote:
> > On Tue, 18 Mar 2008 18:20:45 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > > What's the permission problem?  executable-but-not-readable files?  Could
> > > 
> > > Not writable. 
> > 
> > Oh.
> > 
> > I doubt if a userspace implementation would even try to alter the ELF
> > files, really - there seems to be no point in it.   This is just complexity
> 
> Well the information has to be somewhere and i think the ELF file
> is the best location for it. It makes it the most user transparent.

Adopt a standard, stick with it.

Assuming that all users have the same access pattern might be inefficient,
a little bit.  There might be some advantage to making it per-user, dunno.

The requirement to write to an executable sounds like a bit of a
showstopper.

> > > Yes it could, but i dont even want to thi nk about all the issues of
> > > doing such an interface. It is basically an microkernelish approach.
> > > I prefer monolithic simplicity.
> > 
> > It's not complex at all.  Pass a null-terminated pathname to the server and
> > keep running.  The server will asynchronously read your pages for you.
> 
> But how do you update the bitmap in your scheme? 

umm,

	BITMAP_TRAINING_RUN=1 /usr/lib64/firefox-2.0.0.12/firefox-bin

will write the bitmap to ~/.bitmaps/usr/lib64/firefox-2.0.0.12/firefox-bin ?

if it proves useful, build it all into libc..


I'm assuming that the per-page minor fault cost is relatively low and that
the major benefit is in disk scheduling[*].  If that's false then we'd need
kernel support I guess - some sort of gang-fault syscall?


* solid-state disks are going to put a lot of code out of a job.

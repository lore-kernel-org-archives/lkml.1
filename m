Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbYCST3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbYCST3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:29:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbYCSTZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:25:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39313 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753384AbYCSTZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:25:39 -0400
Date: Tue, 18 Mar 2008 10:44:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Message-Id: <20080318104437.966c10ec.akpm@linux-foundation.org>
In-Reply-To: <20080318172045.GI11966@one.firstfloor.org>
References: <20080318209.039112899@firstfloor.org>
	<20080318003620.d84efb95.akpm@linux-foundation.org>
	<20080318141828.GD11966@one.firstfloor.org>
	<20080318095715.27120788.akpm@linux-foundation.org>
	<20080318172045.GI11966@one.firstfloor.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 18:20:45 +0100 Andi Kleen <andi@firstfloor.org> wrote:

> > What's the permission problem?  executable-but-not-readable files?  Could
> 
> Not writable. 

Oh.

I doubt if a userspace implementation would even try to alter the ELF
files, really - there seems to be no point in it.   This is just complexity
which was added by trying to do it in the kernel.

> > be handled by passing your request to a suitable-privileged server process,
> > I guess.
> 
> Yes it could, but i dont even want to thi nk about all the issues of
> doing such an interface. It is basically an microkernelish approach.
> I prefer monolithic simplicity.

It's not complex at all.  Pass a null-terminated pathname to the server and
keep running.  The server will asynchronously read your pages for you.

That's assuming executable+unreadable libraries and binaries actually need
to be handled.  If not: no server needed.

> e.g. i am pretty sure your user space implementation would be far
> more complicated than a nicely streamlined kernel implementation. 
> And I am really not a friend of unnecessary complexity. In the end
> complexity hurts you, no matter if it is in ring 3 or ring 0.

There is no complexity here.

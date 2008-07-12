Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbYGLNiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbYGLNiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 09:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbYGLNh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 09:37:58 -0400
Received: from [194.117.236.238] ([194.117.236.238]:45367 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYGLNh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 09:37:57 -0400
Date: Sat, 12 Jul 2008 16:36:49 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC PATCH 4/5] kmemtrace: SLUB hooks.
Message-ID: <20080712163649.38da0cc8@linux360.ro>
In-Reply-To: <20080712162836.6ea00830@linux360.ro>
References: <1215712946-23572-1-git-send-email-eduard.munteanu@linux360.ro>
	<1215712946-23572-2-git-send-email-eduard.munteanu@linux360.ro>
	<1215712946-23572-3-git-send-email-eduard.munteanu@linux360.ro>
	<1215712946-23572-4-git-send-email-eduard.munteanu@linux360.ro>
	<20080710210617.70975aed@linux360.ro>
	<84144f020807110135w19cb9b5erff143912e5beb78c@mail.gmail.com>
	<487772A3.5040701@linux-foundation.org>
	<20080712162836.6ea00830@linux360.ro>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2008 16:28:36 +0300
Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:

> On Fri, 11 Jul 2008 09:48:03 -0500
> Christoph Lameter <cl@linux-foundation.org> wrote:
> 
> > Pekka Enberg wrote:
> >  
> > > Christoph, can you please take a look at this?
> > 
> > Yeah. I saw it. Is there some high level description as to how this
> > is going to be used?
> 
> Here is the userspace application's git tree:
> http://repo.or.cz/w/kmemtrace-user.git

Basically, you go like this:
1. Boot the kernel, preferably into 'single' runlevel.
2. Mount debugfs and whatever other filesystems.
3. Run kmemtraced, wait a few seconds and stop it.
4*. Check /debug/kmemtrace/total_overruns (debugfs is mounted on /debug)
to see if there were any buffer overruns.
5*. Run kmemtrace-check on all CPU cpu*.out to see if there are any
erroneous events.
6. Run kmemtrace-report with no parameters to get a short summary of
how the allocator performs.

* - you can optionally skip these steps.

To build the userspace app, launch './configure' when running on that
particular kmemtrace-enabled kernel. It should correctly detect the
headers directory. Otherwise, add KERNEL_SOURCES variable as an
argument to configure. Then run 'make'.

BTW, that repo may change, so don't rely on those commits to be
consistent for a long time. I could delete them all and restructure the
project.


	Eduard

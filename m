Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYICD6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYICD6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 23:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYICD6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 23:58:24 -0400
Received: from gherkin.frus.com ([192.158.254.49]:44242 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbYICD6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 23:58:24 -0400
Date: Tue, 2 Sep 2008 22:58:22 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] /proc/mtrr I/O error
Message-ID: <20080903035821.GA2293@gherkin.frus.com>
References: <20080829213824.GA2281@gherkin.frus.com> <20080902154620.314ad5c2.akpm@linux-foundation.org> <86802c440809021608s54725294t5629255bb1f0c9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440809021608s54725294t5629255bb1f0c9@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 04:08:00PM -0700, Yinghai Lu wrote:
> On Tue, Sep 2, 2008 at 3:46 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 29 Aug 2008 16:38:24 -0500
> > Bob Tracy <rct@gherkin.frus.com> wrote:
> >
> >> With 2.6.27-rc4 and possibly earlier kernels, I see the following:
> >>
> >> $ cat /proc/mtrr
> >> cat: /proc/mtrr: Input/output error
> >>
> >> Processor is an AMD K6-III/450.
> >>
> >
> > static int mtrr_open(struct inode *inode, struct file *file)
> > {
> >        if (!mtrr_if)
> >                return -EIO;
> >
> >
> >
> > Beats me.  Perhaps something broke in mtrr_bp_init().
> >
> > It would be useful to know if 2.6.26 worked OK.
> >
> 
> two patches needed..
> 
> http://lkml.org/lkml/2008/9/1/307
>    [PATCH 4/6] x86: delay early cpu initialization until cpuid is done
> http://lkml.org/lkml/2008/9/1/308
>   [PATCH 5/6] x86: move mtrr cpu cap setting early in early_init_xxxx

Krzysztof Helt's quick-and-dirty patch posted a few days ago did the
trick, but from the descriptions of the above patches, they address the
problem properly.  Here's what "cat /proc/mtrr" shows with Helt's patch
and the "nv" driver active for my GeForce2 MX 400 card:

$ cat /proc/mtrr
reg00: base=0xd0000000 (3328MB), size=  64MB: write-combining, count=1

MTRR sanitization seems to be working properly: the same command shows
nothing when X isn't running.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYA1K5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYA1K5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:57:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYA1K4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:56:48 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:4711 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYA1K4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:56:47 -0500
Date: Mon, 28 Jan 2008 10:57:03 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Abhishek Sagar <sagar.abhishek@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       ananth@in.ibm.com
Subject: Re: [PATCH -mm] kprobes: kretprobe user entry-handler (updated)
Message-ID: <20080128105702.GE12910@shadowen.org>
References: <479B7A78.5090604@gmail.com> <20080127213257.0889c523.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080127213257.0889c523.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 09:32:57PM -0800, Andrew Morton wrote:
> On Sat, 26 Jan 2008 23:52:48 +0530 Abhishek Sagar <sagar.abhishek@gmail.com> wrote:
> 
> > This is a repost of a patch which was reviewed earlier at:
> > http://lkml.org/lkml/2007/11/13/58 (thanks to Jim Keniston and Srinivasa for their review comments). This provides support to add an optional user defined callback to be run at function entry of a kretprobe'd function. It also modifies the kprobe smoke tests to include an entry-handler during the kretprobe sanity test.
> > 
> 
> Neither the changelog nor the newly-added documentation explain why Linux
> needs this feature.  What will it be used for??
> 
> 
> > +1.3.2 Kretprobe entry-handler
> > +
> > +Kretprobes also provides an optional user-specified handler which runs
> 
> I think "caller-specified" would be a better term here.  Generally "user"
> refers to Aunt Tillie sitting at the keyboard.
> 
> > +/* Timestamp function entry. */
> > +static int entry_handler(struct kretprobe_instance *ri, struct pt_regs *regs)
> > +{
> > +	struct my_data *data;
> > +
> > +	if(!current->mm)
> > +		return 1; /* skip kernel threads */
> 
> gargh, what's happened to checkpatch lately?  It failed to notice the
> missing space.

This had me going for a while.  This was missed as this code is not
actually in a source file.  Its actually found in Documentation/kprobes.txt
and we do not apply source level checks to non-source file types.

Hmmm.

-apw

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbXIJHuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbXIJHuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 03:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbXIJHuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 03:50:04 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55943 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794AbXIJHuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 03:50:01 -0400
Date: Mon, 10 Sep 2007 00:49:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Oliver Neukum <oliver@neukum.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] [-mm] FS: file name must be unique in the same dir in
 procfs
Message-Id: <20070910004927.323763ad.akpm@linux-foundation.org>
In-Reply-To: <1187625005.2920.167.camel@acpi-hp.sh.intel.com>
References: <1187605699.2920.147.camel@acpi-hp.sh.intel.com>
	<200708201245.17780.oliver@neukum.org>
	<1187625005.2920.167.camel@acpi-hp.sh.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2007 23:50:05 +0800 Zhang Rui <rui.zhang@intel.com> wrote:

> Hi, Oliver,
> Thanks for your comments,
> 
> On Mon, 2007-08-20 at 18:45 +0800, Oliver Neukum wrote:
> > Am Montag 20 August 2007 schrieb Zhang Rui:
> > > Files name must be unique in the same directory.
> > >
> > > Bug is reported here:
> > > http://bugzilla.kernel.org/show_bug.cgi?id=8798
> > 
> > Then I'd say fix the callers.
> But at least the callers need to be told that something is wrong first.
> 
> >  This will paper over bugs.
> Hmm, what kind of bugs?
> callers always need to check the return value when calling
> proc_mkdir/create_proc_entry, don't they?
> 

Yes, but there's some risk that such a change will cause a
presently-working system to stop working.  It's quite likely, if that
system is checking the procfs-creation return value.

So I think it'd be best if we were to detect the duplication and print a
warning (which should include, if possible, the full pathname and a
dump_stack()) and then the code should proceed as normal: permit the
duplicated entry and return success.

Then, when such duplicates are reported, we can work out what to do about
them on a case-by-case basis.

(btw, please feed your patches through scripts/checkpatch.pl - that one had
a remarkably high coding-style-error-density).

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755342AbZBXBKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342AbZBXBKu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:10:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbZBXBKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:10:42 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:60583 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZBXBKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:10:41 -0500
Date: Mon, 23 Feb 2009 19:10:37 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 3/5] check files for checkpointability
Message-ID: <20090224011037.GB4797@us.ibm.com>
References: <20090219182007.B4B47C1F@kernel> <20090219182009.1A3E8860@kernel> <20090223234911.GB2590@us.ibm.com> <1235435430.26788.212.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235435430.26788.212.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Mon, 2009-02-23 at 17:49 -0600, Serge E. Hallyn wrote:
> > Quoting Dave Hansen (dave@linux.vnet.ibm.com): 
> > > Introduce a files_struct counter to indicate whether a particular
> > > file_struct has ever contained a file which can not be
> > > checkpointed.  This flag is a one-way trip; once it is set, it may
> > > not be unset.
> > > 
> > > We assume at allocation that a new files_struct is clean and may
> > > be checkpointed.  However, as soon as it has had its files filled
> > > from its parent's, we check it for real in __scan_files_for_cr().
> > > At that point, we mark it if it contained any uncheckpointable
> > > files.
> > > 
> > > We also check each 'struct file' when it is installed in a fd
> > > slot.  This way, if anyone open()s or managed to dup() an
> > > unsuppored file, we can catch it.
> > 
> > So what is the point of tagging the files_struct counter and
> > making it a one-way trip?  Why not just check every file at
> > checkpoint time?
> 
> We need both.
> 
> This allows us to tell where and when we went wrong.  Take a process
> that's been running for a month.  After 5 days it did something random
> to keep it from being checkpointed.  You're going to have forgotten all
> about it 25 days later.  This gives us an opportunity to spit into dmesg
> or just plain log it.  It also gives the app some ability to reflect and
> see what its uncheckpointable attributes are.  

Hmm.  In that case, rather than refuse checkpoint, I prefer that we make
this a footnote in the /proc/$$/checkpointable output.

-serge

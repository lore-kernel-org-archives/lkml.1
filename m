Return-Path: <linux-kernel-owner+w=401wt.eu-S1767583AbXDFKnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767583AbXDFKnH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 06:43:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767585AbXDFKnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 06:43:07 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59049 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767583AbXDFKnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 06:43:05 -0400
Date: Fri, 6 Apr 2007 05:43:01 -0500
From: Robin Holt <holt@sgi.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Robin Holt <holt@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
Message-ID: <20070406104301.GB19755@lnx-holt.americas.sgi.com>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <Pine.LNX.4.64.0704051352370.6730@woody.linux-foundation.org> <46159987.6090006@redhat.com> <Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org> <m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So I think we have some options once we get the kernel threads out
> of the way.  Getting the kernel threads out of the way would seem
> to be the first priority.

I think both avenues would probably be the right way to proceeed.
Getting kthreads to not be parented by init would be an opportunity
for optimization.

I think organizing the zombie tasks to be easily reaped also has merit.
Rapidly forking/exiting processes like udevd during the boot of a
different machine were also shown to benefit significantly from this
patch.  That machine had 512 cpus and 4608 disk devices, we dropped the
device discovery under udevd by 30%.  This, honestly, surprised us.
It makes some sense now that I think about it.  This would be a case
where improving the zombie handling would be beneficial to more than
just kthreads.

Thanks,
Robin

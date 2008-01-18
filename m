Return-Path: <linux-kernel-owner+w=401wt.eu-S1762686AbYARQQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762686AbYARQQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760537AbYARQQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:16:11 -0500
Received: from ns.suse.de ([195.135.220.2]:43425 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759983AbYARQQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:16:10 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CPA boot crash (was: [PATCH] [0/36] Great change_page_attr patch series v3)
Date: Fri, 18 Jan 2008 17:16:05 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, jbeulich@novell.com,
       venkatesh.pallipadi@intel.com
References: <200801161114.239449000@suse.de> <200801181701.04549.ak@suse.de> <20080118160757.GA24507@elte.hu>
In-Reply-To: <20080118160757.GA24507@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801181716.06093.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 17:07:57 Ingo Molnar wrote:
> 
> * Andi Kleen <ak@suse.de> wrote:
> 
> > > could you please make your queue bisectable?
> > 
> > The idea was that you git revert the original patches I referenced and 
> > then drop the undo patches since I reimplement all that in different 
> > ways (except for the white space changes, but that can be redone once 
> > everything settled down again). Then it will be bisectable.
> 
> and how does that again make things bisectable in the middle of the PAT 
> queue? For example if i undo:
> 
>   Subject: x86: pat: cpa, 32-bit
>   From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>

Ok sorry only the pageattr_32 hunks would need to be undone.

So it would be something like:

drop venki's 32bit patch
insert my patch to add cpa_addr()
reinsert venki's patch with the pageattr_32 hunks dropped after it

drop venki's 64bit patch
insert my patch to add reserved checking on 64bit cpa
reinsert venki's patch with the pageattr_64 hunks dropped after it

The result should be bisectable.

> > (except for the white space changes, but that can be redone once 
> > everything settled down again). Then it will be bisectable.
> 
> it's a revert barrier (within v2.6.25),

What is a revert barrier?

Anyways of course the way to handle that is the same as with the other undo
patches: drop the original white space changes (ddb53b5735793a19dc17bcd98b050f672f) 
completely and then drop that undo patch too. The white space changes haven't reached 
Linus yet so you can just make them disappear completely from known history.

-Andi

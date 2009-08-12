Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbZHLRg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbZHLRg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 13:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZHLRg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 13:36:28 -0400
Received: from sparc.brc.ubc.ca ([137.82.2.12]:60029 "EHLO sparc.brc.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754617AbZHLRg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 13:36:27 -0400
Date: Wed, 12 Aug 2009 10:58:19 -0700 (PDT)
From: Vincent Li <macli@brc.ubc.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
       rientjes@google.com, mel@csn.ul.ie, mpm@selenic.com
Subject: Re: [PATCH] fs/proc/: fix input sanity check.
In-Reply-To: <20090811150528.a9bc7719.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.00.0908121003180.21620@mail.selltech.ca>
References: <1250026466-8769-1-git-send-email-macli@brc.ubc.ca> <20090811150528.a9bc7719.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009, Andrew Morton wrote:

> On Tue, 11 Aug 2009 14:34:26 -0700
> Vincent Li <macli@brc.ubc.ca> wrote:
> 
> > fix fs/proc/task_mmu.c clear_refs_write(), fs/proc/base.c proc_fault_inject_write()
> >  and proc_fault_inject_operations() input sanity check by following the disccusion of
> > http://marc.info/?l=linux-mm&m=124938168905463&w=2.
> 
> Would prefer that the changelog not consist of a link to another patch
> which is already quite poorly changelogged, please!

It make sense to me only after you point it out to me, That is process of 
learning :)

> 
> What, precisely was wrong with the old code and how does the patch
> change its behaviour.
>

It is after I read your comment about the strange handling of userspace 
string input http://marc.info/?l=linux-mm&m=124890923527186&w=2 and 
Kosaki's "fix oom_adjust_write() input sanity check" patch to match your 
comment http://marc.info/?l=linux-mm&m=124938168905463&w=2.

I re-read the clear_refs_write() in fs/proc/task_mmu.c, If I understand it 
correctly, The old code takes  non-zero string 
from userspace and convert it to unsigned long interger value. for 
example,It accepts:

echo 1 > /proc/pid/clear_refs
echo 12foo > /proc/pid/clear_refs

The new code add the stripping of leading and trailing whitespace, remove 
the obfuscated check for zero-length input at the end of the function as 
you commented. Will this new code break the existing application 
behaviour? David Rientjes is the author of clear_refs, I cced him to see 
if he has any comment.
     
I have not read the proc_fault_inject_write() and 
proc_fault_inject_operations() yet, I will drop the changes to those two 
functions

> 
> This matters.  The patch potentially changes the kernel<->userspace
> interface and we must fully understand the nature of that change so as
> to minimise the risk of breaking existing userspace application code.
> 

Point taken, I am in a rush to post the patch without fully understanding 
what the functions do and the impact of patch changes.

> Thanks.

You are welcome.

Vincent Li
Biomedical Research Center
University of British Columbia

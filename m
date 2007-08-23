Return-Path: <linux-kernel-owner+w=401wt.eu-S932958AbXHWXxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958AbXHWXxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 19:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbXHWXxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 19:53:14 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41640 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758824AbXHWXxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 19:53:14 -0400
Date: Thu, 23 Aug 2007 16:52:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Zan Lynx <zlynx@acm.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: 2.6.23-rc3-mm1 - memory layout change?  - lost support for
 MAP_32BIT? - mono crashes
Message-Id: <20070823165201.717ed62d.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708231126380.2460@twin.jikos.cz>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<1187834905.190825.16.camel@localhost>
	<Pine.LNX.4.64.0708231126380.2460@twin.jikos.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2007 11:28:25 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> Handle MAP_32BIT flags properly in x86_64 flexmmap
> 
> We need to handle MAP_32BIT flags of mmap() properly for 64bit 
> applications with filexible mmap layout.
> 
> This patch introduces x86_64-specific version of 
> arch_get_unmapped_area_topdown() which differs from the generic one in 
> handling of the MAP_32BIT flag -- when this flag is passed to mmap(), we 
> stick back to the legacy layout for this particular mmap, which gives 
> proper 32bit range.
> 

 arch/x86_64/kernel/sys_x86_64.c |   98 ++++++++++++++++++++++++++++++++++++++++
 include/asm-x86_64/pgtable.h    |    1 

well that's another hunk of code for us to maintain and to slow all our
computers down.

It is quite unobvious to me that the whole pie-randomization thing is
worth merging.  Why shouldn't we just drop the lot?


<looks at the changelog>

  This patch is using mmap()'s randomization functionality in such a way
  that it maps the main executable of (specially compiled/linked
  -pie/-fpie) ET_DYN binaries onto a random address (in cases in which
  mmap() is allowed to perform a randomization).

  The code has been extraced from Ingo's exec-shield patch
  http://people.redhat.com/mingo/exec-shield/

that certainly doesn't tell anyone why we should merge this code into Linux.

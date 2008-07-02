Return-Path: <linux-kernel-owner+w=401wt.eu-S1763151AbYGBLsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763151AbYGBLsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 07:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbYGBLsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 07:48:30 -0400
Received: from ozlabs.org ([203.10.76.45]:44230 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239AbYGBLs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:48:29 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18539.27303.187681.716560@cargo.ozlabs.ibm.com>
Date: Wed, 2 Jul 2008 21:46:47 +1000
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: Is sysfs the right place to get cache and CPU topology info?
In-Reply-To: <20080702030154.67a851d2.akpm@linux-foundation.org>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com>
	<20080702003755.4daff613.akpm@linux-foundation.org>
	<18539.20039.516803.51920@cargo.ozlabs.ibm.com>
	<20080702030154.67a851d2.akpm@linux-foundation.org>
X-Mailer: VM 8.0.9 under Emacs 22.1.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> Oh.  I thought "they" (or you) were proposing adding some new
> topology-exporting files to sysfs.

I was proposing adding them on powerpc using the same format and
location as x86 already uses.  That way the HPC library can use the
one parsing routine on both x86 and powerpc.

> If they're talking about using the existing ones then sure, those are
> cast in stone as far as I'm concerned.
> 
> But they do need to be a _bit_ defensive.  If they see a file which has
> multiple name:value fields (shouldn't happen) then don't fail if new
> tuples turn up later on.  Don't expect them to always be in the same
> order.  Don't fail if new files later turn up in a sysfs directory.  If
> a file has (a stupid) format like /proc/self/stat then be prepared for
> new columns to appear later on, etc.
> 
> But if basic and obvious steps like that are taken in the library, and
> later kernel changes cause that library to break, we get to fix the
> kernel to unbreak their library.

I assume they can rely on finding the stuff they need under
/sys/devices/system/cpu.  Or do they need to traverse the whole of
/sys, and if so, how would they know which directories they should be
looking in?

Paul.

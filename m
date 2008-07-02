Return-Path: <linux-kernel-owner+w=401wt.eu-S1762644AbYGBKCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762644AbYGBKCN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 06:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYGBKB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 06:01:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32795 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751767AbYGBKB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 06:01:58 -0400
Date: Wed, 2 Jul 2008 03:01:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: Re: Is sysfs the right place to get cache and CPU topology info?
Message-Id: <20080702030154.67a851d2.akpm@linux-foundation.org>
In-Reply-To: <18539.20039.516803.51920@cargo.ozlabs.ibm.com>
References: <18539.8141.683072.967851@cargo.ozlabs.ibm.com>
	<20080702003755.4daff613.akpm@linux-foundation.org>
	<18539.20039.516803.51920@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2008 19:45:43 +1000 Paul Mackerras <paulus@samba.org> wrote:

> > Well it's up to them - they own the files.  If they later change them
> > and break their own interfaces (and presumably their own applications),
> > well, perhaps they have chosen an inappropriate career?
> 
> We have too many "they"s, perhaps.  I meant that these developers (of
> an HPC library that wants to know about cpu caches and topology) see
> sysfs as being completely useless as a source of information because
> they expect random kernel developers to keep changing it in
> incompatible ways.  So "they" (library developers) don't own the files
> - they're not kernel developers at all.

Oh.  I thought "they" (or you) were proposing adding some new
topology-exporting files to sysfs.

If they're talking about using the existing ones then sure, those are
cast in stone as far as I'm concerned.

But they do need to be a _bit_ defensive.  If they see a file which has
multiple name:value fields (shouldn't happen) then don't fail if new
tuples turn up later on.  Don't expect them to always be in the same
order.  Don't fail if new files later turn up in a sysfs directory.  If
a file has (a stupid) format like /proc/self/stat then be prepared for
new columns to appear later on, etc.

But if basic and obvious steps like that are taken in the library, and
later kernel changes cause that library to break, we get to fix the
kernel to unbreak their library.

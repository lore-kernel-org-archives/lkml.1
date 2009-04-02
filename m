Return-Path: <linux-kernel-owner+w=401wt.eu-S1763366AbZDBQNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763366AbZDBQNM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbZDBQM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:12:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51656 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbZDBQM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:12:56 -0400
Date: Thu, 2 Apr 2009 09:09:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Janne Grunau <j@jannau.net>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-Id: <20090402090912.cac200bb.akpm@linux-foundation.org>
In-Reply-To: <20090402110532.GA5132@aniel>
References: <20090325183011.GN32307@mit.edu>
	<alpine.LFD.2.00.0903251139260.3032@localhost.localdomain>
	<20090325220530.GR32307@mit.edu>
	<alpine.LFD.2.00.0903251622420.3032@localhost.localdomain>
	<20090326171148.9bf8f1ec.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
	<20090326174704.cd36bf7b.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0903261752110.3994@localhost.localdomain>
	<20090326182519.d576d703.akpm@linux-foundation.org>
	<20090401210337.GB3797@csclub.uwaterloo.ca>
	<20090402110532.GA5132@aniel>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Apr 2009 13:05:32 +0200 Janne Grunau <j@jannau.net> wrote:

> MythTV calls fsync every few seconds on ongoing recordings to prevent
> stalls due to large cache writebacks on ext3.

It should use sync_file_range(SYNC_FILE_RANGE_WRITE).  That will

- have minimum latency.  It tries to avoid blocking at all.

- avoid writing metadata

- avoid syncing other unrelated files within ext3

- avoid waiting for the ext3 commit to complete.


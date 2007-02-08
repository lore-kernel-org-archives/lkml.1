Return-Path: <linux-kernel-owner+w=401wt.eu-S1423109AbXBHJBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423109AbXBHJBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 04:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423110AbXBHJBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 04:01:42 -0500
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:39769
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423109AbXBHJBl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 04:01:41 -0500
Date: Thu, 8 Feb 2007 01:01:21 -0800
To: Christoph Hellwig <hch@lst.de>
Cc: jack@suse.cz, akpm@osdl.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>,
       Peter Zijlstra <peter@programming.kicks-ass.net>
Subject: Re: [PATCH] remove sb->s_files and file_list_lock usage in dquot.c
Message-ID: <20070208090121.GA28005@gnuppy.monkey.org>
References: <20070206132333.GA9919@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206132333.GA9919@lst.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 02:23:33PM +0100, Christoph Hellwig wrote:
> Iterate over sb->s_inodes instead of sb->s_files in add_dquot_ref.
> This reduces list search and lock hold time aswell as getting rid of
> one of the few uses of file_list_lock which Ingo identified as a
> scalability problem.

Christoph,

The i_mutex lock the inode structure is also a source of contention
heavy when running a lot of parallel "find"s. I'm sure that folks
would be open to hearing suggestions regarding how to fix that.

bill


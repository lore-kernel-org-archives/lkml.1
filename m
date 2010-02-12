Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab0BLTmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 14:42:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34976 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757185Ab0BLTmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 14:42:46 -0500
Date: Fri, 12 Feb 2010 11:39:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de,
       fengguang.wu@intel.com
Subject: Re: [PATCH 2/3] mm: Implement writeback livelock avoidance using
 page tagging
Message-Id: <20100212113955.4c023130.akpm@linux-foundation.org>
In-Reply-To: <1265929584-5080-3-git-send-email-jack@suse.cz>
References: <1265929584-5080-1-git-send-email-jack@suse.cz>
	<1265929584-5080-3-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 00:06:23 +0100
Jan Kara <jack@suse.cz> wrote:

> The idea is simple: Tag all pages that should be written back
> with a special tag (TOWRITE) in the radix tree. This can be done
> rather quickly and thus livelocks should not happen in practice.
> Then we start doing the hard work of locking pages and sending
> them to disk only for those pages that have TOWRITE tag set.

Adding a second pass across all the pages sounds expensive?

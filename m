Return-Path: <linux-kernel-owner+w=401wt.eu-S1760185AbZIPVs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185AbZIPVs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760176AbZIPVsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:48:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44774 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760170AbZIPVsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:48:54 -0400
Date: Wed, 16 Sep 2009 14:48:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, jack@suse.cz,
       reiserfs-devel@vger.kernel.org, jeffm@suse.com,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] reiserfs: Truncate blocks not used by a write (v2)
Message-Id: <20090916144815.e544b319.akpm@linux-foundation.org>
In-Reply-To: <1253121912-20718-1-git-send-email-jack@suse.cz>
References: <1253121912-20718-1-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Sep 2009 19:25:12 +0200
Jan Kara <jack@suse.cz> wrote:

> It can happen that write does not use all the blocks allocated in write_begin
> either because of some filesystem error (like ENOSPC) or because page with
> data to write has been removed from memory. We truncate these blocks so that
> we don't have dangling blocks beyond i_size.

This clashes a bit with the kill-the-bkl/reiserfs stuff in linux-next.

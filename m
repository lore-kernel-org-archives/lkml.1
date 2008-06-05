Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbYFESr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbYFESr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 14:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbYFESrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 14:47:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49493 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753216AbYFESrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 14:47:18 -0400
Date: Thu, 5 Jun 2008 11:42:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: tigran@aivazian.fsnet.co.uk, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/2] Remove BKL from the bfs driver
Message-Id: <20080605114213.239d66aa.akpm@linux-foundation.org>
In-Reply-To: <1212690397-25693-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1212690397-25693-1-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Jun 2008 21:26:35 +0300
Dmitri Vorobiev <dmitri.vorobiev@movial.fi> wrote:

> This removes quite a few instances of BKL usage in the bfs
> driver. Given the purpose and the user base of this driver,
> I do not believe that a finer-granularity lock than the big
> fat filesystem-wide mutex I have implemented here is needed.

How well tested was this?  With lockdep enabled?

Because the new mutex cannot be taken recursively, whereas the BKL can.
And there's potential for ab/ba deadlocks with, for example, i_mutex.

However I don't see any such problems from a moderately intensive
review.

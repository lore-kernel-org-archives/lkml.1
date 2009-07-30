Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZG3AAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZG3AAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 20:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755258AbZG3AAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 20:00:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38035 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755233AbZG3AAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 20:00:47 -0400
Date: Wed, 29 Jul 2009 17:00:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmemleak: Protect the seq start/next/stop sequence by
 rcu_read_lock()
Message-Id: <20090729170007.f4e60858.akpm@linux-foundation.org>
In-Reply-To: <20090729152101.1878.71159.stgit@pc1117.cambridge.arm.com>
References: <20090729152101.1878.71159.stgit@pc1117.cambridge.arm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jul 2009 16:26:57 +0100
Catalin Marinas <catalin.marinas@arm.com> wrote:

> Objects passed to kmemleak_seq_next() have an incremented reference
> count (hence not freed) but they may point via object_list.next to
> other freed objects. To avoid this, the whole start/next/stop sequence
> must be protected by rcu_read_lock().
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
> 
> This is a fix for bug #13761 in buzilla.kernel.org. If there are no
> objections, please apply it before 2.6.31. Thanks.

Administrivia:

When referencing a bugzilla report, please quote the full URL within
the changelog (not after the ^---$).  I use:

	Addresses http://bugzilla.kernel.org/show_bug.cgi?id=13761

This is because people ocassionally troll the commit logs, closing off
bugzilla reports.  Using a standardised format simplifies that job, and
makes it more reliable.

Also, it's nice to give the original bug reporter a Reported-by: in the
changelog.  As a little thank-you, and so they know what's going on.


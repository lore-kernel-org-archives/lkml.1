Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbYFWUyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbYFWUyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 16:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbYFWUyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 16:54:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753780AbYFWUyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 16:54:06 -0400
Date: Mon, 23 Jun 2008 13:52:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: oleg@tv-sign.ru, ebiederm@xmission.com, mingo@elte.hu,
       torvalds@linux-foundation.org, roland@redhat.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: [PATCH 1/3] introduce PF_KTHREAD flag
Message-Id: <20080623135253.ed7cabf1.akpm@linux-foundation.org>
In-Reply-To: <20080623134706.f5e1ef32.akpm@linux-foundation.org>
References: <20080601153042.GA8238@tv-sign.ru>
	<20080623134037.8566f651.akpm@linux-foundation.org>
	<20080623134706.f5e1ef32.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2008 13:47:06 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I don't yet know how much additional damage will happen as a result.

Lots.

I restored the patches and just dropped the hunk:

  static int has_mm(struct task_struct *p)
  {
-       return (p->mm && !(p->flags & PF_BORROWED_MM));
  }
  
  /**
--- 86,92 ----
  
  static int has_mm(struct task_struct *p)
  {
+       return (p->mm && !(p->flags & PF_KTHREAD));
  }

due to that function having been turned into:

static inline bool should_send_signal(struct task_struct *p)
{
        return !(p->flags & PF_FREEZER_NOSIG);
}

Please check the result?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1762978AbZD3WvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978AbZD3WvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbZD3WvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:51:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57858 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbZD3WvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:51:13 -0400
Date: Thu, 30 Apr 2009 15:49:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: npiggin@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch] oom: prevent livelock when oom_kill_allocating_task is
 set
Message-Id: <20090430154920.64c9c866.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0904301538270.12627@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0904301538270.12627@chino.kir.corp.google.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 15:38:53 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> When /proc/sys/vm/oom_kill_allocating_task is set for large systems that
> want to avoid the lengthy tasklist scan, it's possible to livelock if
> current is ineligible for oom kill.  This normally happens when it is set
> to OOM_DISABLE, but is also possible if any threads are sharing the same
> ->mm with a different tgid.

OK...  And how does the patch address this problem?

<reads the code>

Seems that if we were unable to kill `current', we'll ignore the
oom_kill_allocating_task setting and will fall back the slow tasklist
scan?


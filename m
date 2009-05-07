Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbZEGUAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbZEGUAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbZEGUAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:00:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42516 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754415AbZEGUAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:00:24 -0400
Date: Thu, 7 May 2009 12:55:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: chrisw@sous-sol.org, oleg@redhat.com, roland@redhat.com,
       linux-kernel@vger.kernel.org, viro@ZenIV.linux.org.uk
Subject: Re: [patch 1/2] ptrace, security: rename ptrace_may_access =>
 ptrace_access_check
Message-Id: <20090507125526.c257c23d.akpm@linux-foundation.org>
In-Reply-To: <20090507094947.GA4911@elte.hu>
References: <20090506080050.GF17457@elte.hu>
	<20090506235349.GC3756@redhat.com>
	<20090507002133.02D05FC39E@magilla.sf.frob.com>
	<20090507063606.GA15220@redhat.com>
	<20090507082027.GD12285@elte.hu>
	<20090507083102.GA20125@redhat.com>
	<20090507083851.GA19133@elte.hu>
	<20090507085742.GB3036@sequoia.sous-sol.org>
	<20090507090459.GE19133@elte.hu>
	<20090507093124.GA355@elte.hu>
	<20090507094947.GA4911@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 11:49:47 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> The ptrace_may_access() methods are named confusingly - some 
> variants return a bool, while the security subsystem methods have a 
> retval convention.
> 
> Rename it to ptrace_access_check, to reduce the confusion factor. A 
> followup patch eliminates the bool usage.

s/may_access/access_check/ is a poor change.  The new name conveys less
information than the old one.

It's quite clear what the return value from "may_access" means.  It's
less clear what the return value from a function called "access_check"
means.

Switching to something like ptrace_task_accessible() or
ptrace_may_access_task() would be better.

This happens quite often.  The string "check" in the name of a
predicate function is a red flag.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758634AbXHAEty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634AbXHAEty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 00:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbXHAEto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 00:49:44 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752478AbXHAEtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 00:49:43 -0400
Date: Tue, 31 Jul 2007 21:49:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Frank Benkstein <frank-lkml@benkstein.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: VT_PROCESS, VT_LOCKSWITCH capabilities
Message-Id: <20070731214931.8d05f367.akpm@linux-foundation.org>
In-Reply-To: <46AFB62E.2080303@benkstein.net>
References: <46AFB62E.2080303@benkstein.net>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 00:22:38 +0200 Frank Benkstein <frank-lkml@benkstein.net> wrote:

> I wonder why there are different permissions needed for VT_PROCESS
> (access to the current virtual console) and VT_LOCKSWITCH
> (CAP_SYS_TTY_CONFIG).
> 
> The first one lets the calling process decide if console switching is
> allowed, the second one simply disables it.  If a program wants to
> forbid console switching the only technical difference I can see is that
> switching is automatically reenabled when the program exits when using
> VT_PROCESS.  When using VT_LOCKSWITCH it must be manually reenabled.
> When the program uses the first method and disables terminal signals and
> SysRQ is disabled, too, I see no practical difference between the two.

It'd take some kernel archaeology to work out how things got the way they
are.

Perhaps the issue with VT_LOCKSWITCH is that its effects will persist after
the user has logged out?  So user A is effectively altering user B's
console, hence suitable capabilities are needed?

Is the current code actually causing any observable problem?

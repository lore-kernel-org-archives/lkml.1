Return-Path: <linux-kernel-owner+w=401wt.eu-S1763676AbXHAJxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763676AbXHAJxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 05:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758093AbXHAJxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 05:53:32 -0400
Received: from norsk.toidinamai.de ([78.47.249.60]:34657 "EHLO
	norsk.toidinamai.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760033AbXHAJxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 05:53:31 -0400
Message-ID: <46B05817.5070305@benkstein.net>
Date: Wed, 01 Aug 2007 11:53:27 +0200
From: Frank Benkstein <frank-lkml@benkstein.net>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: VT_PROCESS, VT_LOCKSWITCH capabilities
References: <46AFB62E.2080303@benkstein.net> <20070731214931.8d05f367.akpm@linux-foundation.org>
In-Reply-To: <20070731214931.8d05f367.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 01 Aug 2007 00:22:38 +0200 Frank Benkstein <frank-lkml@benkstein.net> wrote:
> 
>> I wonder why there are different permissions needed for VT_PROCESS
>> (access to the current virtual console) and VT_LOCKSWITCH
>> (CAP_SYS_TTY_CONFIG).
>>
> Perhaps the issue with VT_LOCKSWITCH is that its effects will persist after
> the user has logged out?  So user A is effectively altering user B's
> console, hence suitable capabilities are needed?
> 
> Is the current code actually causing any observable problem?

Both controls can be used to deny service to other users.  For example:
user B locks his X session or current console and walks off to lunch.
User A walks up to user B's machine, switches to another console, logs
in and execs program_that_does_vt_process.  User B will not be able to
continue work unless he/she can get user A or someone with CAP_KILL to
kill the program.  If remote logins aren't allowed, the only way I see
to use the machine again is to reboot.

I think VT_PROCESS (or VT_SETMODE respectively) should be protected with
the same level of security as VT_LOCKSWITCH, i.e. CAP_SYS_TTY_CONFIG.

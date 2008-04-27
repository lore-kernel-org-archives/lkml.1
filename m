Return-Path: <linux-kernel-owner+w=401wt.eu-S1763453AbYD0UhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763453AbYD0UhK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751002AbYD0Ug6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:36:58 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50651 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYD0Ug5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:36:57 -0400
Date: Sun, 27 Apr 2008 21:36:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-sparse@vger.kernel.org
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
Message-ID: <20080427203638.GW5882@ZenIV.linux.org.uk>
References: <1209327591.14173.74.camel@brick> <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org> <1209328161.14173.77.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209328161.14173.77.camel@brick>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 01:29:21PM -0700, Harvey Harrison wrote:

> Oh, I didn't realize, I only did this because sparse started spewing out
> lots of:
> include/linux/bitops.h:166:32: warning: shift too big (65536) for type unsigned long
> 
> due to shift by size there, and again on line 202...I just wanted something
> that sparse wouldn't warn about and was a little easier to understand to boot.

That's a sparse problem, really.  I wonder if we simply should introduce a
new node type: EXPR_WARN.  So that expand would generate those from things
like division by zero/overflow/bad shift *and* emitting an insn for those
would generate a stored warning.

Objections?

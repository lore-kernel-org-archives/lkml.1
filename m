Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYAFVb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYAFVb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 16:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbYAFVbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 16:31:50 -0500
Received: from lazybastard.de ([212.112.238.170]:36834 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbYAFVbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 16:31:50 -0500
Date: Sun, 6 Jan 2008 22:25:42 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, peterz@infradead.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block2mtd lockdep_init_map warning
Message-ID: <20080106212542.GA5262@lazybastard.org>
References: <20080106131343.GA3120@lazybastard.org> <200801061911.m06JBldW020012@agora.fsl.cs.sunysb.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200801061911.m06JBldW020012@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 January 2008 14:11:47 -0500, Erez Zadok wrote:
> 
> The problem appears to be an interaction of two components--module loading
> and lockdep--that's perhaps why it wasn't given enough attention.

Correct.  For modules lockdep depends on initializations done after
module_init has finished.  However block2mtd is an odd sod that can call
into lockdep code during module_init, causing the bug you noticed.

Several solutions are possible.  Modules could get two initcalls, one to
decide whether module load should get aborted, the other run later,
after the remaining module initializations are done.  Or the module
loader could always do the initializations and revoke them later, if
module_init failed.

But I personally am too unfamiliar with the module code to trust my
judgement and have yet to receive feedback.  Even you seem to ignore my
mails and not even Cc: me later on.  I must have done something really
horrible in my last life, it seems.

Jörn

-- 
A quarrel is quickly settled when deserted by one party; there is
no battle unless there be two.
-- Seneca

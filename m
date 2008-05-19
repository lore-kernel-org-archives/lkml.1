Return-Path: <linux-kernel-owner+w=401wt.eu-S1764493AbYESWTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764493AbYESWTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765669AbYESWSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:18:11 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:41181 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764824AbYESWSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:18:08 -0400
X-IronPort-AV: E=Sophos;i="4.27,511,1204531200"; 
   d="scan'208";a="101017149"
From: Roland Dreier <rdreier@cisco.com>
To: corbet@lwn.net (Jonathan Corbet)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH, RFC] Char dev BKL pushdown v2
References: <19108.1211229722@vena.lwn.net>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 19 May 2008 15:18:06 -0700
In-Reply-To: <19108.1211229722@vena.lwn.net> (Jonathan Corbet's message of
	"Mon, 19 May 2008 14:42:02 -0600")
Message-ID: <aday7665469.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 19 May 2008 22:18:06.0569 (UTC) FILETIME=[36683590:01C8B9FE]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > That's part of it, but, as Alan pointed out, there's more.  The BKL
 > currently protects open() calls against concurrency with other opens,
 > with ioctl(), and with driver initialization as well.  So it's a matter
 > of having one's locking and ordering act together in general.

Thanks.  Just to be super-explicit, ioctl() cannot be called on a given
file until the open() for that particular file has returned, right?

And the point about driver initialization is that open() can be called
as soon as the file operations are registered, even if the module_init
function has not returned?

Thanks,
  Roland

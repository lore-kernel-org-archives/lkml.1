Return-Path: <linux-kernel-owner+w=401wt.eu-S1752306AbYJVDC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752306AbYJVDC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 23:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYJVDCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 23:02:48 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:44803 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYJVDCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 23:02:47 -0400
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
	restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Daniel Jacobowitz <dan@debian.org>
Cc: Oren Laadan <orenl@cs.columbia.edu>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20081022025513.GA7504@caradoc.them.org>
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu>
	 <1224481237-4892-3-git-send-email-orenl@cs.columbia.edu>
	 <20081021124130.a002e838.akpm@linux-foundation.org>
	 <20081021202410.GA10423@us.ibm.com> <48FE82DF.6030005@cs.columbia.edu>
	 <20081022025513.GA7504@caradoc.them.org>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 20:02:43 -0700
Message-Id: <1224644563.1848.232.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-21 at 22:55 -0400, Daniel Jacobowitz wrote:
> I haven't been following - but why this whole container restriction?
> Checkpoint/restart of individual processes is very useful too.
> There are issues with e.g. IPC, but I'm not convinced they're
> substantially different than the issues already present for a
> container.

Containers provide isolation.  Once you have isolation, you have a
discrete set of resources which you can checkpoint/restart.

Let's say you have a process you want to checkpoint.  If it uses a
completely discrete IPC namespace, you *know* that nothing else depends
on those IPC ids.  We don't even have to worry about who might have been
using them and when.

Also think about pids.  Without containers, how can you guarantee a
restarted process that it can regain the same pid?

-- Dave


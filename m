Return-Path: <linux-kernel-owner+w=401wt.eu-S1755885AbYJVO3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbYJVO3V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYJVO3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:29:12 -0400
Received: from NaN.false.org ([208.75.86.248]:33843 "EHLO nan.false.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbYJVO3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:29:10 -0400
Date: Wed, 22 Oct 2008 10:29:07 -0400
From: Daniel Jacobowitz <dan@debian.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
	restart
Message-ID: <20081022142907.GA13574@caradoc.them.org>
Mail-Followup-To: Dave Hansen <dave@linux.vnet.ibm.com>,
	Oren Laadan <orenl@cs.columbia.edu>, linux-api@vger.kernel.org,
	containers@lists.linux-foundation.org, mingo@elte.hu,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	viro@zeniv.linux.org.uk, hpa@zytor.com,
	Andrew Morton <akpm@linux-foundation.org>,
	torvalds@linux-foundation.org, tglx@linutronix.de
References: <1224481237-4892-1-git-send-email-orenl@cs.columbia.edu> <1224481237-4892-3-git-send-email-orenl@cs.columbia.edu> <20081021124130.a002e838.akpm@linux-foundation.org> <20081021202410.GA10423@us.ibm.com> <48FE82DF.6030005@cs.columbia.edu> <20081022025513.GA7504@caradoc.them.org> <1224644563.1848.232.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224644563.1848.232.camel@nimitz>
User-Agent: Mutt/1.5.17 (2008-05-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2008 at 08:02:43PM -0700, Dave Hansen wrote:
> Let's say you have a process you want to checkpoint.  If it uses a
> completely discrete IPC namespace, you *know* that nothing else depends
> on those IPC ids.  We don't even have to worry about who might have been
> using them and when.
> 
> Also think about pids.  Without containers, how can you guarantee a
> restarted process that it can regain the same pid?

OK, that makes sense.  In a lot of simple cases you can get by without
regaining the same pid; there's an implementation of checkpointing in
GDB that works by injecting fork calls into the child, and it is
useful for a reasonable selection of single-threaded programs.

-- 
Daniel Jacobowitz
CodeSourcery

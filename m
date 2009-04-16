Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbZDPQza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbZDPQza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 12:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753686AbZDPQzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 12:55:21 -0400
Received: from verein.lst.de ([213.95.11.210]:37815 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbZDPQzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 12:55:20 -0400
Date: Thu, 16 Apr 2009 18:52:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Theodore Tso <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 0/8] [GIT PULL] TRACE_EVENT for modules
Message-ID: <20090416165224.GD5933@lst.de>
References: <20090414172337.280621613@goodmis.org> <20090414210445.GM955@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414210445.GM955@mit.edu>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 05:04:45PM -0400, Theodore Tso wrote:
> One thing which I would really like is to avoid needing to drop the
> header file in include/trace/<subsystem.h>.
> 
> The problem that I have with this is that for ext4, we need to access
> private data structures which are defined in header files in
> fs/ext4/*.h --- which we moved into fs/ext4 a long time ago at the
> request of those who felt include/linux/* was getting rather
> cluttered, and if a subsystem had header files which were only needed
> by files for that particular subsystems, they should be moved out of
> include/linux.  

Same is true for XFS, or just about any other self-contained in a module
subsystem I can think of.  My current XFS trace events stuff includes
tons of headers in the xfs header in include/trace and adds -Ifs/xfs to
kernel/trace/Makefile.  The latter should be gone by the new
implementation compiling the tracing stubs into the module, but it's
still not pretty.


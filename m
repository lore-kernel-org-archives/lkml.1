Return-Path: <linux-kernel-owner+w=401wt.eu-S1756214AbZDNVc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214AbZDNVc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 17:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbZDNVcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 17:32:15 -0400
Received: from thunk.org ([69.25.196.29]:56814 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292AbZDNVcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 17:32:14 -0400
Date: Tue, 14 Apr 2009 17:32:07 -0400
From: Theodore Tso <tytso@mit.edu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: blktrace: event traces displayed wrong while ftrace blktrace
	is active
Message-ID: <20090414213207.GP955@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
References: <E1LtUBT-0007kq-HU@closure.thunk.org> <49E45F7B.7060709@cn.fujitsu.com> <20090414212532.GD5968@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414212532.GD5968@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 11:25:33PM +0200, Frederic Weisbecker wrote:
> 
> Indeed. Note that you can overwrite this default by typing:
> 
> echo context-info > trace_option
> 
> after setting bkltrace as the current tracer.

The problem with doing that is that blktrace will then display this:

    fsync-tester-27934 [001]   208.031278:     fsync-tester-27934 [001]   208.031278: 254,4    Q  WS 268392 + 8 [fsync-tester]

I think the real problem is that blk trace is displaying the standard
context-info, so it's suppressing the normal context info.  So I have
the choice on having no context information on my event trace lines,
or two copies of the context information for the block trace lines.  

:-(

I'm guessing things were done this way in order to support the old
legancy blktrace format?

						- Ted

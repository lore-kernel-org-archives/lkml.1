Return-Path: <linux-kernel-owner+w=401wt.eu-S1757051AbZDOAQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051AbZDOAQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZDOAQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:16:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36181 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912AbZDOAQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:16:36 -0400
Date: Tue, 14 Apr 2009 21:16:17 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Jens Axboe <jens.axboe@oracle.com>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: blktrace: event traces displayed wrong while ftrace blktrace
	is active
Message-ID: <20090415001617.GB8359@ghostprotocols.net>
References: <E1LtUBT-0007kq-HU@closure.thunk.org> <49E45F7B.7060709@cn.fujitsu.com> <20090414212532.GD5968@nowhere> <20090414213207.GP955@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414213207.GP955@mit.edu>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Apr 14, 2009 at 05:32:07PM -0400, Theodore Tso escreveu:
> On Tue, Apr 14, 2009 at 11:25:33PM +0200, Frederic Weisbecker wrote:
> > 
> > Indeed. Note that you can overwrite this default by typing:
> > 
> > echo context-info > trace_option
> > 
> > after setting bkltrace as the current tracer.
> 
> The problem with doing that is that blktrace will then display this:
> 
>     fsync-tester-27934 [001]   208.031278:     fsync-tester-27934 [001]   208.031278: 254,4    Q  WS 268392 + 8 [fsync-tester]
> 
> I think the real problem is that blk trace is displaying the standard
> context-info, so it's suppressing the normal context info.  So I have
> the choice on having no context information on my event trace lines,
> or two copies of the context information for the block trace lines.  
> 
> :-(
> 
> I'm guessing things were done this way in order to support the old
> legancy blktrace format?

Well, last time I worked in this code the default was to use the default
context information, not duplicate it, and if one used:

echo blk_classic > /sys/kernel/debug/tracing/trace_options

Then it would look like the output of blktrace(8).

Lemme try to boot the current code...

- Arnaldo

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbXIUAEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbXIUAEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 20:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbXIUAEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 20:04:01 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3253 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbXIUAEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 20:04:01 -0400
Subject: Re: [Announce] Linux-tiny project revival
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Tim Bird <tim.bird@am.sony.com>, linux-tiny@selenic.com,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
In-Reply-To: <200709201928.49440.rob@landley.net>
References: <46F1645D.9050406@am.sony.com> <46F2ED1E.3090407@am.sony.com>
	 <1190326465.26101.171.camel@localhost> <200709201928.49440.rob@landley.net>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 17:03:30 -0700
Message-Id: <1190333010.26101.220.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 19:28 -0500, Rob Landley wrote:
> You convert printk(KERN_INFO, blah) to pr_INFO(blah)?

more or less.
printk(KERN_INFO foo) to pr_info(foo)
printk(KERN_EMERG foo) to pr_emerge(foo)
etc.

> I'm not finding pr_INFO with a grep on the files in 
> 2.6.23-rc7.

I haven't submitted them.

There's a lot of sensible resistance to what appears
to be churn.  Some of the resistance is historical,
merging large changes used to be much more painful
pre git, some is just simple resistance to change.

I started with submitting an add of pr_err to kernel.h
which Andrew Morton picked up for awhile, but dropped.

I've got a local tree with those changes.

for example:

KERN_EMERG  -> pr_emerg  is  ~100KB
KERN_ALERT  -> pr_alert  is   ~80KB
KERN_CRIT   -> pr_crit   is  ~200KB
KERN_NOTICE -> pr_notice is  ~400KB
KERN_INFO   -> pr_info   is ~2500KB

I intended to strip the "\n" trailer from the messages.

Back to the scripts:

In this case, there are multiple files.

A script that finds all the files that contain a search string, 
and a perl script that effectively s/search/replace/g on those files.

sed didn't work as well as perl here because I wanted to
play with perl a bit and many printk(KERN_<level> foo)
function calls are split across multiple lines.

I've still got to show a real use to this change set.

I believe controlling the interleaving of log messages
by having multiple statement printks have a start and end,
choosing specific message levels in compiled code,
and choosing to print file/function/line per compiled
code block might do, but more utility to the changes
is probably necessary before it could be applied.

cheers, Joe


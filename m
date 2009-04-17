Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbZDQVa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbZDQVa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbZDQVaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:30:06 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1285 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbZDQVaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:30:04 -0400
Subject: Re: [PATCH 0/10] MAINTAINERS - add script, patterns and misc
 updates
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
References: <1239167872-8179-1-git-send-email-joe@perches.com>
	 <20090417134711.ba0f03e7.randy.dunlap@oracle.com>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 14:27:32 -0700
Message-Id: <1240003652.31116.44.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 13:47 -0700, Randy Dunlap wrote:
> On Tue,  7 Apr 2009 22:17:42 -0700 Joe Perches wrote:
> I was hoping to get the patch that changed all pairs of
> P:
> M:
> lines to one line that is suitable for pasting into email addresses.
> Are we supposed to use get_maintainer.pl for that?

I merely wanted to get the patterns accepted.

I thought the P/M: integration was an unnecessary
complication that would delay pattern acceptance.

So I use scripts/get_maintainer.pl "as is".
Suggestions on improvements to the script are
of course gladly accepted...

If the script doesn't work well for you, please
let me know.

If the P/M: conversion is desired, I've no objection.
The script would have to change though.

There are command line options to control email address
output style:

For instance:

$ ./scripts/get_maintainer.pl -f Documentation/DocBook/sh.tmpl 
linux-doc@vger.kernel.org
linux-kernel@vger.kernel.org
Randy Dunlap <rdunlap@xenotime.net>
Paul Mundt <lethal@linux-sh.org>

with option "--no-n" (also "--non") (Do not output "name")

$ ./scripts/get_maintainer.pl --no-n -f Documentation/DocBook/sh.tmpl 
linux-doc@vger.kernel.org
linux-kernel@vger.kernel.org
rdunlap@xenotime.net
lethal@linux-sh.org

with option "--no-l" (do not output "mailing lists")

$ ./scripts/get_maintainer.pl --no-l -f Documentation/DocBook/sh.tmpl
Randy Dunlap <rdunlap@xenotime.net>
Paul Mundt <lethal@linux-sh.org>

with option "--no-m"
(do not output "maintainers" , just use git log "by:" signors)

$ ./scripts/get_maintainer.pl --no-m -f Documentation/DocBook/sh.tmpl 
linux-doc@vger.kernel.org
linux-kernel@vger.kernel.org
Paul Mundt <lethal@linux-sh.org>

with option "--no-multiline", the output is on a single line

$ ./scripts/get_maintainer.pl --no-multiline -f Documentation/DocBook/sh.tmpl 
linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>, Paul Mundt <lethal@linux-sh.org>

The entry separator (default ", ") is specified with --separator

By default, "subscriber-only" mailing lists are
not output.  Use "--l --s" to output lists and
lists that are "subscriber-only".

There is a defect in the script right now with
"subscriber-only" mailing lists.  The regex
check is not broad enough.

I'll submit a patch for that shortly.

cheers, Joe


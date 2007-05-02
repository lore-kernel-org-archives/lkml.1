Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921AbXEBHKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbXEBHKs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 03:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbXEBHKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 03:10:48 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:46693 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750962AbXEBHKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 03:10:37 -0400
Date: Wed, 2 May 2007 00:10:35 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: rientjes@google.com, torvalds@linux-foundation.org,
       clameter@cthulhu.engr.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: allow empty {cpus,mems}_allowed to be set for
 unpopulated cpuset
Message-Id: <20070502001035.873880ba.pj@sgi.com>
In-Reply-To: <6599ad830705012036g21cc8470nff246e146b1e4023@mail.gmail.com>
References: <Pine.LNX.4.64.0705011714490.6376@chino.kir.corp.google.com>
	<20070501202201.6903d922.pj@sgi.com>
	<6599ad830705012036g21cc8470nff246e146b1e4023@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> Otherwise the only way to reclaim
> the node for a different sibling is to delete the cpuset.

I couldn't make sense of that sentence.  Could you restate it?

> Yes, but that's arguably an artefact of the user using the wrong tool
> to update the cpu/node set. Doing "echo -n > /dev/cpuset/foobar/mems"
> has the expected effect.

While it is true that 'echo -n' works here, I think that this will
cause confusion and irritation to users.  We have gone out of our way
for years now to support newlines as optional trailing characters on
input to the various bitmask formats, and to provide the newline on
output, in order to provide a comfortable interface for use from shell
scripts and prompts.

I think it would be an annoying inconsistency to not do so here.

I'd vote for adding a couple of lines of code to handle this:

+	char *bp;

+	bp = buf;
+	while (isspace(*bp))
+		bp++;
+	if (!*bp) {
+		cpus_clear(trialcs.cpus_allowed);
+	} else {

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401

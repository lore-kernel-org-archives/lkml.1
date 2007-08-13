Return-Path: <linux-kernel-owner+w=401wt.eu-S1032210AbXHMRGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032210AbXHMRGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973083AbXHMQqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:46:07 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3148 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S972986AbXHMQp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:45:57 -0400
Subject: Re: [PATCH] [2/2many] - FInd the maintainer(s) for a patch -
	MAINTAINERS
From: Joe Perches <joe@perches.com>
To: Valdis.Kletnieks@vt.edu
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <9866.1187022990@turing-police.cc.vt.edu>
References: <1186985416.10249.13.camel@localhost>
	 <9866.1187022990@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 09:45:43 -0700
Message-Id: <1187023543.10249.107.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 12:36 -0400, Valdis.Kletnieks@vt.edu wrote:
> On Sun, 12 Aug 2007 23:10:16 PDT, Joe Perches said:
> 
> > + A trailing slash includes all files and subdirectory files.
> > + F: drivers/net/ all files in and below drivers/net
> > + F: drivers/net/* all files in drivers/net, but not below
> 
> Since somebody is going to screw up and do it - what are the semantics
> of 'drivers/net' and forgetting the trailing slash?

Looks for a specific file in the patch called drivers/net

> is it silent or noisy (if it's silent, it won't get fixed)

silent

> + F: */net/* all files in "any top level directory"/net
> Does the leading '*' match exactly one level

Yes

> or will it match foo/bar/net/* as

No match, the script counts slashes

+sub file_match_pattern {
+    my ($file, $pattern) = @_;
+    if (substr($pattern, -1) eq "/") {
+       if ($file =~ m@^$pattern@) {
+           return 1;
+       }
+    } else {
+       if ($file =~ m@^$pattern@) {
+           my $s1 = ($file =~ tr@/@@);
+           my $s2 = ($pattern =~ tr@/@@);
+           if ($s1 == $s2) {
+               return 1;
+           }
+       }
+    }
+    return 0;
+}

Enhancements appreciated.

> Is a construction like 'net/*/netfilter/*' legal?

Yes

cheers,  Joe


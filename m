Return-Path: <linux-kernel-owner+w=401wt.eu-S1760839AbXHARXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839AbXHARXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753320AbXHARWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:22:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53494 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307AbXHARWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:22:52 -0400
Date: Wed, 1 Aug 2007 10:22:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, ezk@cs.sunysb.edu, jsipek@cs.sunysb.edu
Subject: Re: unionfs compile error ( Re: 2.6.23-rc1-mm2 )
Message-Id: <20070801102207.f427a17f.akpm@linux-foundation.org>
In-Reply-To: <46B0616E.5000704@googlemail.com>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	<46B0616E.5000704@googlemail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 01 Aug 2007 12:33:18 +0200 Gabriel C <nix.or.die@googlemail.com> wrote:

> ....
> 
> fs/unionfs/file.c:147: error: 'file_fsync' undeclared here (not in a function)
> make[2]: *** [fs/unionfs/file.o] Error 1
> make[1]: *** [fs/unionfs] Error 2
> make: *** [fs] Error 2
> make: *** Waiting for unfinished jobs....
> 
> ...
> 
> Config can be found there -> http://194.231.229.228/MM/config-auto-3
> 

This, I assume:

--- a/fs/unionfs/file.c~git-unionfs-fix-2
+++ a/fs/unionfs/file.c
@@ -17,6 +17,7 @@
  */
 
 #include "union.h"
+#include <linux/buffer_head.h>
 
 /*******************
  * File Operations *
_

(and no, sorry, I will not be complicit in that
single-header-file-which-includes-the-whole-world junk).


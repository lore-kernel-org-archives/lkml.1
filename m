Return-Path: <linux-kernel-owner+w=401wt.eu-S1762986AbYARSGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762986AbYARSGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760160AbYARSG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:06:28 -0500
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:11458 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758119AbYARSG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:06:27 -0500
Date: Fri, 18 Jan 2008 13:06:26 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc8-mm1
Message-ID: <20080118180626.GA12593@phobos.i.cabal.ca>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 02:35:14AM -0800, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc8/2.6.24-rc8-mm1/
> 

Odd nobody else has seen this... oldconfig fails for me on Debian...
kconfig/conf.c is using setlocale() without including the locale.h
header.

  HOSTCC  scripts/kconfig/conf.o
scripts/kconfig/conf.c: In function 'main':
scripts/kconfig/conf.c:502: warning: implicit declaration of function
'setlocale'
scripts/kconfig/conf.c:502: error: 'LC_ALL' undeclared (first use in
this function)
scripts/kconfig/conf.c:502: error: (Each undeclared identifier is
reported only once

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>

--- a/scripts/kconfig/conf.c	2008-01-17 15:45:59.000000000 -0800
+++ b/scripts/kconfig/conf.c	2008-01-18 10:01:54.000000000 -0800
@@ -3,6 +3,8 @@
  * Released under the terms of the GNU GPL v2.0.
  */
 
+#include <locale.h>
+
 #include <ctype.h>
 #include <stdio.h>
 #include <stdlib.h>

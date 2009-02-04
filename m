Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbZBDVNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbZBDVNv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 16:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754998AbZBDVNi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:13:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353AbZBDVNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:13:38 -0500
Date: Wed, 4 Feb 2009 13:12:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, krzysztof.h1@poczta.fm
Subject: Re: mmotm 2009-02-03-19-43 uploaded (cirrusfb)
Message-Id: <20090204131258.b9029211.akpm@linux-foundation.org>
In-Reply-To: <4989D059.9040202@oracle.com>
References: <200902040345.n143jAZh010843@imap1.linux-foundation.org>
	<4989D059.9040202@oracle.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Feb 2009 09:28:57 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-02-03-19-43 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > It contains the following patches against 2.6.29-rc3:
> 
> > cirrusfb-convert-printks-to-dev_foo.patch
> 
> -	DPRINTK("\n");
> +	dev_dbg(info->device, "\n");

Actually

		dev_dbg(info->device,
			"cirrusfb_setup: option '%s'\n", this_opt);

> 
> drivers/video/cirrusfb.c:2397: error: 'info' undeclared (first use in this function)
> 
> 
> Did you build test this??

As a module - that code is inside #ifdef MODULE.

I did the easy fix ;)

--- a/drivers/video/cirrusfb.c~cirrusfb-convert-printks-to-dev_foo-fix-fix2
+++ a/drivers/video/cirrusfb.c
@@ -2384,7 +2384,8 @@ static int __init cirrusfb_init(void)
 }
 
 #ifndef MODULE
-static int __init cirrusfb_setup(char *options) {
+static int __init cirrusfb_setup(char *options)
+{
 	char *this_opt;
 
 	if (!options || !*options)
@@ -2394,9 +2395,6 @@ static int __init cirrusfb_setup(char *o
 		if (!*this_opt)
 			continue;
 
-		dev_dbg(info->device,
-			"cirrusfb_setup: option '%s'\n", this_opt);
-
 		if (!strcmp(this_opt, "noaccel"))
 			noaccel = 1;
 		else if (!strncmp(this_opt, "mode:", 5))
_





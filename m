Return-Path: <linux-kernel-owner+w=401wt.eu-S932461AbXGPPuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbXGPPuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759987AbXGPPuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:50:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757064AbXGPPuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:50:01 -0400
Date: Mon, 16 Jul 2007 11:49:39 -0400
From: Dave Jones <davej@redhat.com>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-kernel@vger.kernel.org, Meelis Roos <mroos@linux.ee>
Subject: Re: [PATCH] 9p: fix debug compilation error
Message-ID: <20070716154939.GA30789@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Eric Van Hensbergen <ericvh@gmail.com>,
	linux-kernel@vger.kernel.org, Meelis Roos <mroos@linux.ee>
References: <Pine.SOC.4.64.0707161432480.1471@math.ut.ee> <11845972692586-git-send-email-ericvh@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11845972692586-git-send-email-ericvh@gmail.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2007 at 09:47:49AM -0500, Eric Van Hensbergen wrote:
 > From: Meelis Roos <mroos@linux.ee>
 > 
 > With 9P but no 9P debug options, this error occurs:
 >   CC [M]  fs/9p/v9fs.o
 > fs/9p/v9fs.c: In function 'v9fs_parse_options':
 > fs/9p/v9fs.c:134: error: 'p9_debug_level' undeclared (first use in this function)
 > 
 > The following patch moves the definition of p9_debug_level out of #ifdef
 > and seems to fix the problem.
 > 
 > (Original patch took care of the extern definition in the includes, but
 > not the actual definition in mod.c - ericvh)

Seems somewhat wasteful to include the debug options when the config
option has been disabled though.
Wouldn't something like this (untested) make more sense ?

	Dave

---  

fs/9p/v9fs.c: In function 'v9fs_parse_options':
fs/9p/v9fs.c:134: error: 'p9_debug_level' undeclared (first use in this function)

Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6.22.noarch/fs/9p/v9fs.c~	2007-07-16 11:45:56.000000000 -0400
+++ linux-2.6.22.noarch/fs/9p/v9fs.c	2007-07-16 11:46:12.000000000 -0400
@@ -131,7 +131,9 @@ static void v9fs_parse_options(char *opt
 		switch (token) {
 		case Opt_debug:
 			v9ses->debug = option;
+#ifdef CONFIG_NET_9P_DEBUG
 			p9_debug_level = option;
+#endif
 			break;
 		case Opt_port:
 			v9ses->port = option;

-- 
http://www.codemonkey.org.uk

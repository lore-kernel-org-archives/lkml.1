Return-Path: <linux-kernel-owner+w=401wt.eu-S934724AbXK3Chf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934724AbXK3Chf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbXK3ChZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:37:25 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:1202 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898AbXK3ChY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:37:24 -0500
Subject: Re: Trailing periods in kernel messages
From: Joe Perches <joe@perches.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Frans Pop <elendil@planet.nl>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, trivial@kernel.org,
       Andy Whitcroft <apw@shadowen.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>
In-Reply-To: <474F6D4D.9010006@cn.fujitsu.com>
References: <474E6BD0.20103@cn.fujitsu.com>
	 <E1IxfE8-0000Sr-9w@faramir.fjphome.nl>	<474E8669.6060409@cn.fujitsu.com>
	 <200711291120.19595.elendil@planet.nl>
	 <20071129032036.4c021617.akpm@linux-foundation.org>
	 <474F6372.70705@cn.fujitsu.com> <1196386259.22120.101.camel@localhost>
	 <474F6D4D.9010006@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 18:35:28 -0800
Message-Id: <1196390128.22120.118.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-30 at 09:54 +0800, Li Zefan wrote:
> So it doesn't deserve the effort to eliminate these periods, isn't it?

I hope these will eventually disappear.

> Or we can add a check to checkpatch.pl to prevent new ones.

Perhaps that's a good idea.

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index cbb4258..707f84c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1390,6 +1390,10 @@ sub process {
 		if ($line =~ /\*\s*\)\s*k[czm]alloc\b/) {
 			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
 		}
+
+		if ($rawline =~ /(print|pr_(emerg|alert|crit|err|warning|notice|info|debug)).*\.\\n\"/) {
+			WARN("unnecessary period before newline\n" . $herecurr);
+		}
 	}
 
 	if ($chk_patch && !$is_patch) {



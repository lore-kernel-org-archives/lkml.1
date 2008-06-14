Return-Path: <linux-kernel-owner+w=401wt.eu-S1764161AbYFNA0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764161AbYFNA0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762269AbYFNAPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:15:21 -0400
Received: from ns2.suse.de ([195.135.220.15]:52203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762255AbYFNAPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:15:20 -0400
Date: Fri, 13 Jun 2008 17:12:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: [patch 42/47] CPUFREQ: Fix format string bug.
Message-ID: <20080614001211.GP24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cpufreq-fix-format-string-bug.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Chris Wright <chrisw@sous-sol.org>

commit 326f6a5c9c9e1a62aec37bdc0c3f8d53adabe77b upstream

Format string bug.  Not exploitable, as this is only writable by root,
but worth fixing all the same.

From: Chris Wright <chrisw@sous-sol.org>
Spotted-by: Ilja van Sprundel <ilja@netric.org>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/cpufreq/cpufreq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -410,7 +410,7 @@ static int cpufreq_parse_governor (char 
 				int ret;
 
 				mutex_unlock(&cpufreq_governor_mutex);
-				ret = request_module(name);
+				ret = request_module("%s", name);
 				mutex_lock(&cpufreq_governor_mutex);
 
 				if (ret == 0)

-- 

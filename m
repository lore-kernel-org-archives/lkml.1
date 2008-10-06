Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbYJFXXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbYJFXXx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756764AbYJFXVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:21:50 -0400
Received: from ns.suse.de ([195.135.220.2]:40787 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756765AbYJFXVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:21:49 -0400
Date: Mon, 6 Oct 2008 16:17:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Andi Kleen <ak@linux.intel.com>,
       Milan Broz <mbroz@redhat.com>
Subject: [patch 07/28] ACPI: Fix thermal shutdowns
Message-ID: <20081006231712.GH20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="acpi-fix-thermal-shutdowns.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Milan Broz <mbroz@redhat.com>

commit 9f497bcc695fb828da023d74ad3c966b1e58ad21 upstream

ACPI: Fix thermal shutdowns

Do not use unsigned int if there is test for negative number...

See drivers/acpi/processor_perflib.c
  static unsigned int ignore_ppc = -1;
...
  if (event == CPUFREQ_START && ignore_ppc <= 0) {
       ignore_ppc = 0;
...

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/processor_perflib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -70,7 +70,7 @@ static DEFINE_MUTEX(performance_mutex);
  *  0 -> cpufreq low level drivers initialized -> consider _PPC values
  *  1 -> ignore _PPC totally -> forced by user through boot param
  */
-static unsigned int ignore_ppc = -1;
+static int ignore_ppc = -1;
 module_param(ignore_ppc, uint, 0644);
 MODULE_PARM_DESC(ignore_ppc, "If the frequency of your machine gets wrongly" \
 		 "limited by BIOS, this should help");

-- 

Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab0APNVW (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 08:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066Ab0APNVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 08:21:21 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:49694 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab0APNVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 08:21:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=OvGOcJQrg11rRxoVykeCCDnuGNK/xq7TDdteMW8GHhy5R/AQv6DhR7ic+JX6LOTVEE
         NQVIDtKZV/CG0oJgUFONmr3Eh2/AU11Crdndl3IqZIQ52TP78WsPyZpOulUupaZbbabS
         PrsU9P3CWlbEjI0kH19pv3BC6EIsbaOJc2Z6Y=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH] perf: Fix implicit declaration of getline in util.c
Date: Sat, 16 Jan 2010 14:21:15 +0100
Message-Id: <1263648075-3858-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

getline() is considered as undeclared in util/util.c because
it includes string.h, that in turn includes stdio.h, without
having defined _GNU_SOURCE.

But util.c also includes util.h that handles the _GNU_SOURCE and
all the needed inclusions already. Let's include only util.h
and sys/mman.h which is the only one header not handled by util.h

This fixes the following build error:

util/util.c: In function ‘slow_copyfile’:
util/util.c:49: erreur: implicit declaration of function ‘getline’
util/util.c:49: erreur: nested extern declaration of ‘getline’

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 tools/perf/util/util.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index f068584..f9b890f 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -1,10 +1,5 @@
-#include <sys/mman.h>
-#include <sys/stat.h>
-#include <sys/types.h>
-#include <fcntl.h>
-#include <string.h>
-#include <unistd.h>
 #include "util.h"
+#include <sys/mman.h>
 
 int mkdir_p(char *path, mode_t mode)
 {
-- 
1.6.2.3


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757451AbZLDWZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757451AbZLDWZQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbZLDWZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:25:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:54331 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757310AbZLDWZJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:25:09 -0500
Message-ID: <4B198CAE.9090501@gmail.com>
Date: Fri, 04 Dec 2009 23:26:54 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: benh@kernel.crashing.org, paulus@samba.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 12/31] Constify struct hv_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct hv_ops with some exceptions.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/char/hvc_beat.c       |    2 +-
 drivers/char/hvc_console.c    |    6 +++---
 drivers/char/hvc_console.h    |    6 +++---
 drivers/char/hvc_iseries.c    |    2 +-
 drivers/char/hvc_iucv.c       |    2 +-
 drivers/char/hvc_rtas.c       |    2 +-
 drivers/char/hvc_udbg.c       |    2 +-
 drivers/char/hvc_vio.c        |    2 +-
 drivers/char/hvc_xen.c        |    2 +-
 drivers/char/virtio_console.c |    1 +
 10 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/char/hvc_beat.c b/drivers/char/hvc_beat.c
index 0afc8b8..6913fc3 100644
--- a/drivers/char/hvc_beat.c
+++ b/drivers/char/hvc_beat.c
@@ -84,7 +84,7 @@ static int hvc_beat_put_chars(uint32_t vtermno, const char *buf, int cnt)
 	return cnt;
 }
 
-static struct hv_ops hvc_beat_get_put_ops = {
+static const struct hv_ops hvc_beat_get_put_ops = {
 	.get_chars = hvc_beat_get_chars,
 	.put_chars = hvc_beat_put_chars,
 };
diff --git a/drivers/char/hvc_console.c b/drivers/char/hvc_console.c
index a632f25..e622e05 100644
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -125,7 +125,7 @@ static struct hvc_struct *hvc_get_by_index(int index)
  * console interfaces but can still be used as a tty device.  This has to be
  * static because kmalloc will not work during early console init.
  */
-static struct hv_ops *cons_ops[MAX_NR_HVC_CONSOLES];
+static const struct hv_ops *cons_ops[MAX_NR_HVC_CONSOLES];
 static uint32_t vtermnos[MAX_NR_HVC_CONSOLES] =
 	{[0 ... MAX_NR_HVC_CONSOLES - 1] = -1};
 
@@ -247,7 +247,7 @@ static void destroy_hvc_struct(struct kref *kref)
  * vty adapters do NOT get an hvc_instantiate() callback since they
  * appear after early console init.
  */
-int hvc_instantiate(uint32_t vtermno, int index, struct hv_ops *ops)
+int hvc_instantiate(uint32_t vtermno, int index, const struct hv_ops *ops)
 {
 	struct hvc_struct *hp;
 
@@ -749,7 +749,7 @@ static const struct tty_operations hvc_ops = {
 };
 
 struct hvc_struct __devinit *hvc_alloc(uint32_t vtermno, int data,
-					struct hv_ops *ops, int outbuf_size)
+					const struct hv_ops *ops, int outbuf_size)
 {
 	struct hvc_struct *hp;
 	int i;
diff --git a/drivers/char/hvc_console.h b/drivers/char/hvc_console.h
index 10950ca..ed176c3 100644
--- a/drivers/char/hvc_console.h
+++ b/drivers/char/hvc_console.h
@@ -55,7 +55,7 @@ struct hvc_struct {
 	int outbuf_size;
 	int n_outbuf;
 	uint32_t vtermno;
-	struct hv_ops *ops;
+	const struct hv_ops *ops;
 	int irq_requested;
 	int data;
 	struct winsize ws;
@@ -76,11 +76,11 @@ struct hv_ops {
 };
 
 /* Register a vterm and a slot index for use as a console (console_init) */
-extern int hvc_instantiate(uint32_t vtermno, int index, struct hv_ops *ops);
+extern int hvc_instantiate(uint32_t vtermno, int index, const struct hv_ops *ops);
 
 /* register a vterm for hvc tty operation (module_init or hotplug add) */
 extern struct hvc_struct * __devinit hvc_alloc(uint32_t vtermno, int data,
-				struct hv_ops *ops, int outbuf_size);
+				const struct hv_ops *ops, int outbuf_size);
 /* remove a vterm from hvc tty operation (module_exit or hotplug remove) */
 extern int hvc_remove(struct hvc_struct *hp);
 
diff --git a/drivers/char/hvc_iseries.c b/drivers/char/hvc_iseries.c
index 936d05b..fd02426 100644
--- a/drivers/char/hvc_iseries.c
+++ b/drivers/char/hvc_iseries.c
@@ -197,7 +197,7 @@ done:
 	return sent;
 }
 
-static struct hv_ops hvc_get_put_ops = {
+static const struct hv_ops hvc_get_put_ops = {
 	.get_chars = get_chars,
 	.put_chars = put_chars,
 	.notifier_add = notifier_add_irq,
diff --git a/drivers/char/hvc_iucv.c b/drivers/char/hvc_iucv.c
index b8a5d65..619f7d1 100644
--- a/drivers/char/hvc_iucv.c
+++ b/drivers/char/hvc_iucv.c
@@ -922,7 +922,7 @@ static int hvc_iucv_pm_restore_thaw(struct device *dev)
 
 
 /* HVC operations */
-static struct hv_ops hvc_iucv_ops = {
+static const struct hv_ops hvc_iucv_ops = {
 	.get_chars = hvc_iucv_get_chars,
 	.put_chars = hvc_iucv_put_chars,
 	.notifier_add = hvc_iucv_notifier_add,
diff --git a/drivers/char/hvc_rtas.c b/drivers/char/hvc_rtas.c
index 88590d0..61c4a61 100644
--- a/drivers/char/hvc_rtas.c
+++ b/drivers/char/hvc_rtas.c
@@ -71,7 +71,7 @@ static int hvc_rtas_read_console(uint32_t vtermno, char *buf, int count)
 	return i;
 }
 
-static struct hv_ops hvc_rtas_get_put_ops = {
+static const struct hv_ops hvc_rtas_get_put_ops = {
 	.get_chars = hvc_rtas_read_console,
 	.put_chars = hvc_rtas_write_console,
 };
diff --git a/drivers/char/hvc_udbg.c b/drivers/char/hvc_udbg.c
index bd63ba8..b0957e6 100644
--- a/drivers/char/hvc_udbg.c
+++ b/drivers/char/hvc_udbg.c
@@ -58,7 +58,7 @@ static int hvc_udbg_get(uint32_t vtermno, char *buf, int count)
 	return i;
 }
 
-static struct hv_ops hvc_udbg_ops = {
+static const struct hv_ops hvc_udbg_ops = {
 	.get_chars = hvc_udbg_get,
 	.put_chars = hvc_udbg_put,
 };
diff --git a/drivers/char/hvc_vio.c b/drivers/char/hvc_vio.c
index 10be343..27370e9 100644
--- a/drivers/char/hvc_vio.c
+++ b/drivers/char/hvc_vio.c
@@ -77,7 +77,7 @@ static int filtered_get_chars(uint32_t vtermno, char *buf, int count)
 	return got;
 }
 
-static struct hv_ops hvc_get_put_ops = {
+static const struct hv_ops hvc_get_put_ops = {
 	.get_chars = filtered_get_chars,
 	.put_chars = hvc_put_chars,
 	.notifier_add = notifier_add_irq,
diff --git a/drivers/char/hvc_xen.c b/drivers/char/hvc_xen.c
index a6ee32b..94f8c26 100644
--- a/drivers/char/hvc_xen.c
+++ b/drivers/char/hvc_xen.c
@@ -120,7 +120,7 @@ static int read_console(uint32_t vtermno, char *buf, int len)
 	return recv;
 }
 
-static struct hv_ops hvc_ops = {
+static const struct hv_ops hvc_ops = {
 	.get_chars = read_console,
 	.put_chars = write_console,
 	.notifier_add = notifier_add_irq,
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index a035ae3..cc50600 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -44,6 +44,7 @@ static unsigned int in_len;
 static char *in, *inbuf;
 
 /* The operations for our console. */
+/* cannot be const */
 static struct hv_ops virtio_cons;
 
 /* The hvc device */

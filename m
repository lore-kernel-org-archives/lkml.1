Return-Path: <linux-kernel-owner+w=401wt.eu-S1760240AbYEMURY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbYEMURY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762031AbYEMUOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:14:24 -0400
Received: from ns2.suse.de ([195.135.220.15]:38150 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762024AbYEMUOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:14:22 -0400
Date: Tue, 13 May 2008 13:11:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 12/37] serial: Fix sparc driver name strings.
Message-ID: <20080513201158.GM31167@suse.de>
References: <20080513200453.064446337@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="serial-fix-sparc-driver-name-strings.patch"
In-Reply-To: <20080513201053.GA31167@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit: b53e5216e5f73330bffae93b42dceb94e361f4c0 ]

They were all "serial" so if multiple of these drivers registered,
we'd trigger sysfs directory creation errors:

[    1.695793] proc_dir_entry 'serial' already registered
[    1.695839] Call Trace:
[    1.831891]  [00000000004f2534] create_proc_entry+0x7c/0x98
[    1.833608]  [00000000004f3a58] proc_tty_register_driver+0x40/0x70
[    1.833663]  [0000000000594700] tty_register_driver+0x1fc/0x208
[    1.835371]  [00000000005aade4] uart_register_driver+0x134/0x16c
[    1.841762]  [00000000005ac274] sunserial_register_minors+0x34/0x68
[    1.841818]  [00000000007db2a4] sunsu_init+0xf8/0x150
[    1.867697]  [00000000007c62a4] kernel_init+0x190/0x330
[    1.939147]  [0000000000426cf8] kernel_thread+0x38/0x48
[    1.939198]  [00000000006a0d90] rest_init+0x18/0x5c

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/sunhv.c    |    2 +-
 drivers/serial/sunsab.c   |    2 +-
 drivers/serial/sunsu.c    |    2 +-
 drivers/serial/sunzilog.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/serial/sunhv.c
+++ b/drivers/serial/sunhv.c
@@ -392,7 +392,7 @@ static struct uart_ops sunhv_pops = {
 
 static struct uart_driver sunhv_reg = {
 	.owner			= THIS_MODULE,
-	.driver_name		= "serial",
+	.driver_name		= "sunhv",
 	.dev_name		= "ttyS",
 	.major			= TTY_MAJOR,
 };
--- a/drivers/serial/sunsab.c
+++ b/drivers/serial/sunsab.c
@@ -826,7 +826,7 @@ static struct uart_ops sunsab_pops = {
 
 static struct uart_driver sunsab_reg = {
 	.owner			= THIS_MODULE,
-	.driver_name		= "serial",
+	.driver_name		= "sunsab",
 	.dev_name		= "ttyS",
 	.major			= TTY_MAJOR,
 };
--- a/drivers/serial/sunsu.c
+++ b/drivers/serial/sunsu.c
@@ -1173,7 +1173,7 @@ out:
 
 static struct uart_driver sunsu_reg = {
 	.owner			= THIS_MODULE,
-	.driver_name		= "serial",
+	.driver_name		= "sunsu",
 	.dev_name		= "ttyS",
 	.major			= TTY_MAJOR,
 };
--- a/drivers/serial/sunzilog.c
+++ b/drivers/serial/sunzilog.c
@@ -1023,7 +1023,7 @@ static struct uart_sunzilog_port *sunzil
 
 static struct uart_driver sunzilog_reg = {
 	.owner		=	THIS_MODULE,
-	.driver_name	=	"ttyS",
+	.driver_name	=	"sunzilog",
 	.dev_name	=	"ttyS",
 	.major		=	TTY_MAJOR,
 };

-- 

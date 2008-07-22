Return-Path: <linux-kernel-owner+w=401wt.eu-S1759471AbYGVXa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471AbYGVXa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756593AbYGVXXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:23:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:58196 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756200AbYGVXXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:23:03 -0400
Date: Tue, 22 Jul 2008 16:17:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Eric W. Biederman" <ebiederm@xmission.com>, Alan Cox <alan@redhat.com>
Subject: [patch 37/47] serial8250: sanity check nr_uarts on all paths.
Message-ID: <20080722231710.GL8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="serial8250-sanity-check-nr_uarts-on-all-paths.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Eric W. Biederman <ebiederm@xmission.com>

commit 05d81d2222beec7b63ac8c1c8cdb5bb4f82c2bad upstream

I had 8250.nr_uarts=16 in the boot line of a test kernel and I had a weird
mysterious crash in sysfs.  After taking an in-depth look I realized that
CONFIG_SERIAL_8250_NR_UARTS was set to 4 and I was walking off the end of
the serial8250_ports array.

Ouch!!!

Don't let this happen to someone else.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/8250.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2564,6 +2564,9 @@ static struct console serial8250_console
 
 static int __init serial8250_console_init(void)
 {
+	if (nr_uarts > UART_NR)
+		nr_uarts = UART_NR;
+
 	serial8250_isa_init_ports();
 	register_console(&serial8250_console);
 	return 0;

-- 

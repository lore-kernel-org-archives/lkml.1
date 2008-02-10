Return-Path: <linux-kernel-owner+w=401wt.eu-S1751979AbYBJNuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751979AbYBJNuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 08:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbYBJNuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 08:50:24 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:47865 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYBJNuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 08:50:23 -0500
Message-ID: <47AF011D.5050301@web.de>
Date: Sun, 10 Feb 2008 14:50:21 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [4/6] consoles: polling support, kgdboc
References: <20080210071339.GD3851@elte.hu>
In-Reply-To: <20080210071339.GD3851@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX194maXdxx6JLbn8suddvfs8s78lpzfG1DbzFPmW
	jF2HYEQlmSZDcCcRpAt8Gw6tCn32OiA+EY0KsbrjhYoOoyLLdd
	an5J5cGNw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> From: Jan Kiszka <jan.kiszka@siemens.com>
> 

Well, actually not from me but from Jason. I think I just touched it
last for the configuration cleanups.

However, this fragment is additionally required to avoid crashes when
doing runtime reconfigurations. To avoid the ifdef'ery of the original
version, I just killed the __init - tiny-linux people may cry now...


Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 serial_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 8e6dce3..a72116a 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1827,7 +1827,7 @@ uart_get_console(struct uart_port *ports, int nr, struct console *co)
  *	options.  The format of the string is <baud><parity><bits><flow>,
  *	eg: 115200n8r
  */
-void __init
+void
 uart_parse_options(char *options, int *baud, int *parity, int *bits, int *flow)
 {
 	char *s = options;
@@ -1872,7 +1872,7 @@ static const struct baud_rates baud_rates[] = {
  *	@bits: number of data bits
  *	@flow: flow control character - 'r' (rts)
  */
-int __init
+int
 uart_set_options(struct uart_port *port, struct console *co,
 		 int baud, int parity, int bits, int flow)
 {

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbYA1KUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbYA1KUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:20:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755584AbYA1KUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:20:03 -0500
Received: from lizzard.sbs.de ([194.138.37.39]:16831 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbYA1KUB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:20:01 -0500
Message-ID: <479DAC35.60308@siemens.com>
Date: Mon, 28 Jan 2008 11:19:33 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: kgdb-bugreport@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: KGDB: 8250_kgdb warnings
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

so far I ignored this because it worked, but I know my customer will
complain later anyway: What is the deeper meaning of this warning which
shows up once per registered UART port on my (x86) boxes?

void kgdb8250_add_port(int i, struct uart_port *serial_req)
{
#ifdef CONFIG_KGDB_SIMPLE_SERIAL
	if (should_copy_rs_table)
		printk(KERN_ERR "8250_kgdb: warning will over write serial"
			   " port definitions at kgdb init time\n");
#endif
...

When I look at kgdb8250_add_platform_port, it starts with a call to
kgdb8250_copy_rs_table, and I'm wondering now if that wouldn't be more
appropriate here.

Jan

-- 
Siemens AG, Corporate Technology, CT SE 2
Corporate Competence Center Embedded Linux

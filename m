Return-Path: <linux-kernel-owner+w=401wt.eu-S1755261AbYIESwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbYIESwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbYIESwA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:52:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33217 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180AbYIESwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:52:00 -0400
Date: Fri, 5 Sep 2008 20:51:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] x86 fixes
Message-ID: <20080905185141.GA4739@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

which fixes sporadic boot-time lockups on certain boxes. Thanks,

	Ingo

------------------>
Chuck Ebbert (1):
      x86: add io delay quirk for Presario F700


 arch/x86/kernel/io_delay.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/io_delay.c b/arch/x86/kernel/io_delay.c
index 1c3a66a..720d260 100644
--- a/arch/x86/kernel/io_delay.c
+++ b/arch/x86/kernel/io_delay.c
@@ -92,6 +92,14 @@ static struct dmi_system_id __initdata io_delay_0xed_port_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "30BF")
 		}
 	},
+	{
+		.callback	= dmi_io_delay_0xed_port,
+		.ident		= "Presario F700",
+		.matches	= {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Quanta"),
+			DMI_MATCH(DMI_BOARD_NAME, "30D3")
+		}
+	},
 	{ }
 };
 

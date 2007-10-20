Return-Path: <linux-kernel-owner+w=401wt.eu-S1764978AbXJTSS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764978AbXJTSS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 14:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756099AbXJTSSu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 14:18:50 -0400
Received: from xenotime.net ([66.160.160.81]:36635 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755968AbXJTSSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 14:18:49 -0400
Date: Sat, 20 Oct 2007 11:18:47 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>, zippel@linux-m68k.org
Subject: Re: [PATCH] xconfig: set title bar
Message-Id: <20071020111847.a5cfb02c.rdunlap@xenotime.net>
In-Reply-To: <20071020171403.GD6855@uranus.ravnborg.org>
References: <20071019145528.1cdeb007.randy.dunlap@oracle.com>
	<20071020171403.GD6855@uranus.ravnborg.org>
Organization: YPO4
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2007 19:14:03 +0200 Sam Ravnborg wrote:

> I found this one to work:
> +       setCaption("hello my little world");

Thanks, your search expressions were better than mine.

> We should show the prompt associated with mainmenu here.

You want all 3 of them converted to
	symbol_value(mainmenu) + $KERNELVERSION
?

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Put kernel version info on title bar in xconfig (qconf) instead of
defaulting to "qconf".

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/kconfig/qconf.cc |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.23-git13.orig/scripts/kconfig/qconf.cc
+++ linux-2.6.23-git13/scripts/kconfig/qconf.cc
@@ -1274,8 +1274,12 @@ ConfigMainWindow::ConfigMainWindow(void)
 	QMenuBar* menu;
 	bool ok;
 	int x, y, width, height;
+	char title[256];
 
 	QWidget *d = configApp->desktop();
+	sprintf(title, _("Linux Kernel v%s Configuration"),
+		getenv("KERNELVERSION"));
+	setCaption(title);
 
 	width = configSettings->readNumEntry("/window width", d->width() - 64);
 	height = configSettings->readNumEntry("/window height", d->height() - 64);


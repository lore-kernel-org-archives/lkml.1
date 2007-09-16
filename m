Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbXIPSjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbXIPSjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 14:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbXIPSjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 14:39:47 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48091 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbXIPSjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 14:39:46 -0400
Date: Sun, 16 Sep 2007 20:41:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Matej Laitl <strohel@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] menuconfig: distinguish between selected-by-another options and comments
Message-ID: <20070916184110.GB9630@uranus.ravnborg.org>
References: <200709152004.11930.strohel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200709152004.11930.strohel@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2007 at 08:04:10PM +0200, Matej Laitl wrote:
> menuconfig currently represents options implied by another option ('select'
> directive in Kconfig) by prefixing them with '---'. Unfortunately the same
> notation is used for comments.
This is easy to fix - example below.

Now a comment looks like this

   *** This is a comment ***

Notice the three leading spaces which is where '---' was before.

	Sam

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index bc5854e..2ee12a7 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -481,6 +481,14 @@ static void build_conf(struct menu *menu)
 				if (single_menu_mode && menu->data)
 					goto conf_childs;
 				return;
+			case P_COMMENT:
+				if (prompt) {
+					child_count++;
+					item_make("   %*c*** %s ***", indent + 1, ' ', prompt);
+					item_set_tag(':');
+					item_set_data(menu);
+				}
+				break;
 			default:
 				if (prompt) {
 					child_count++;

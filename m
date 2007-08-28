Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbXH1KHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbXH1KHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 06:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbXH1KHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 06:07:09 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:25728
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751547AbXH1KHI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 06:07:08 -0400
Message-Id: <46D41006.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 28 Aug 2007 11:07:34 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Subject: [PATCH] store __setup_str_* in a more compact way
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__setup_str_* are referenced only during boot, hence there's no need to
waste image space for aligning these strings (with the aim of improving
performance).

Signed-off-by: Jan Beulich <jbeulich@novell.com>

 include/linux/init.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc4/include/linux/init.h	2007-08-28 09:42:36.000000000 +0200
+++ 2.6.23-rc4-compact-setup-str/include/linux/init.h	2007-08-20 09:28:12.000000000 +0200
@@ -158,7 +158,7 @@ struct obs_kernel_param {
  * obs_kernel_param "array" too far apart in .init.setup.
  */
 #define __setup_param(str, unique_id, fn, early)			\
-	static char __setup_str_##unique_id[] __initdata = str;	\
+	static char __setup_str_##unique_id[] __initdata __aligned(1) = str; \
 	static struct obs_kernel_param __setup_##unique_id	\
 		__attribute_used__				\
 		__attribute__((__section__(".init.setup")))	\




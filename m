Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbYJXHkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbYJXHkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 03:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751174AbYJXHkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 03:40:11 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:46558 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYJXHkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 03:40:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=iCQz5sTj7vnhmxiv+h3i0zkpjBeC3AXSWrAmyeuUv+m41ZiTnt5YznK1KgOFKl2uiV
         uv3DPxbYUAq1SBczIeFCjqErtRxMTZCgfNJvCxh3f9JGuHeQn7wnXghKPbSnwz/ha+hA
         JlWNx0KdhFq+olBdK5/eNl3ku5wGwcYfiN1Tg=
Date: Fri, 24 Oct 2008 15:40:03 +0800
From: Qinghuang Feng <qhfeng.kernel@gmail.com>
To: jason.wessel@windriver.com
Cc: kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH]kgdb:remove redundant function invocation
Message-ID: <20081024074003.GA7338@ubuntu>
Mail-Followup-To: jason.wessel@windriver.com,
	kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems strange to call kgdboc_option_setup with parameter of config from 
configure_kgdboc(), because kgdboc_option_setup() is used to fill config
with stuff in other place. Now, kgdboc_option_setup will fill config
with config itself. But on the other hand, kgdboc_option_setup has a 
additional effect to check whether config overflows or not.

Is it ok to remove kgdboc_option_setup? 

Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
---
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index eadc1ab..03f683e 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -51,8 +51,7 @@ static int configure_kgdboc(void)
 	int tty_line = 0;
 	int err;
 
-	err = kgdboc_option_setup(config);
-	if (err || !strlen(config) || isspace(config[0]))
+	if (!strlen(config) || isspace(config[0]))
 		goto noconfig;
 
 	err = -ENODEV;

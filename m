Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbYGVA3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbYGVA3X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 20:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756087AbYGVA3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 20:29:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:9567 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbYGVA3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 20:29:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=HFGni3Ax/C76MtA+hvRQg01bFuXEdHSU2w0amA6oiACH35R8llSenJAJBKIJib+zHI
         kbUhw9kEwElNq85aBfYZAgc6m4iAdqtMfm8dhxk59sKMQbVYNSElxv4xzSQm8lfuz+dI
         aWgrWhedBsIZa098vUzLwa8hP9hoVtU4SrMXA=
Message-ID: <488529CE.1040907@gmail.com>
Date: Mon, 21 Jul 2008 20:29:02 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: thomas@winischhofer.net
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] sis fb: test below 0 on unsigned type_no
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

u32 type_no, member of structs sis_{crt2,tv}type are unsigned,
so assignment of -1 and subsequent tests fail

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index b934384..9ec6c0e 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -266,7 +266,7 @@ sisfb_search_crt2type(const char *name)
 
 	if(name == NULL) return;
 
-	while(sis_crt2type[i].type_no != -1) {
+	while (sis_crt2type[i].type_no != ~0) {
 		if(!strnicmp(name, sis_crt2type[i].name, strlen(sis_crt2type[i].name))) {
 			sisfb_crt2type = sis_crt2type[i].type_no;
 			sisfb_tvplug = sis_crt2type[i].tvplug_no;
@@ -293,7 +293,7 @@ sisfb_search_tvstd(const char *name)
 	if(name == NULL)
 		return;
 
-	while(sis_tvtype[i].type_no != -1) {
+	while (sis_tvtype[i].type_no != ~0) {
 		if(!strnicmp(name, sis_tvtype[i].name, strlen(sis_tvtype[i].name))) {
 			sisfb_tvstd = sis_tvtype[i].type_no;
 			break;
diff --git a/drivers/video/sis/sis_main.h b/drivers/video/sis/sis_main.h
index 3e3b7fa..5421bf2 100644
--- a/drivers/video/sis/sis_main.h
+++ b/drivers/video/sis/sis_main.h
@@ -390,7 +390,7 @@ static struct _sis_crt2type {
 	{"YPBPR1080I",	     CRT2_TV,   TV_YPBPR|TV_YPBPR1080I, FL_315},
 	{"DSTN",             CRT2_LCD,  -1,                     FL_315|FL_550_DSTN},
 	{"FSTN",             CRT2_LCD,  -1,                     FL_315|FL_550_FSTN},
-	{"\0",  	     -1, 	-1,                     0}
+	{"\0",  	     ~0, 	-1,                     0}
 };
 
 /* TV standard */
@@ -403,7 +403,7 @@ static struct _sis_tvtype {
 	{"PALM",  	TV_PAL|TV_PALM},
 	{"PALN",  	TV_PAL|TV_PALN},
 	{"NTSCJ",  	TV_NTSC|TV_NTSCJ},
-	{"\0",   	-1}
+	{"\0",   	~0}
 };
 
 static const struct _sis_vrate {

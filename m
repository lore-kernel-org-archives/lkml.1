Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbZGMAYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbZGMAYb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 20:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbZGMAYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 20:24:21 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:42002 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbZGMAYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 20:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=w/aMyi4H2saShhB9Ra9TQOJtW3BnsybeqHqnIUhDpatXyNjVU7v0ndwOt3m7xrJr31
         fAsgI+nQmqXi/PlWkzVGnRmwGaG80ZYH7StRDFKsNf2VOIckgm62EEwBN+xU/x2z5o8S
         L0NhtaogX8DXdCnGXhGaU4UK8ZSpTf1YwfzFw=
Message-ID: <4A5A7F0B.4070106@gmail.com>
Date: Mon, 13 Jul 2009 02:25:47 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Keep index within event_type_descriptors[]
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep index within event_type_descriptors[]

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 518a33a..d18c98e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -436,7 +436,7 @@ void print_events(void)
 
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++, syms++) {
 		type = syms->type + 1;
-		if (type > ARRAY_SIZE(event_type_descriptors))
+		if (type >= ARRAY_SIZE(event_type_descriptors))
 			type = 0;
 
 		if (type != prev_type)

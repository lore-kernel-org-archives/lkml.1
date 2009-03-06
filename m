Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZCFIRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZCFIRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 03:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZCFIQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 03:16:56 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:34084 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750761AbZCFIQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 03:16:55 -0500
X-Sasl-enc: XKW45osKr0qvthhH2aCMvRUvySft8A6V++eoghPcsd/S 1236327411
Message-ID: <49B0DBF1.1060800@ladisch.de>
Date: Fri, 06 Mar 2009 09:16:49 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] udf: fix novrs mount option
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The novrs mount option was broken due to a missing break.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

--- linux-2.6.orig/fs/udf/super.c
+++ linux-2.6/fs/udf/super.c
@@ -428,6 +428,7 @@ static int udf_parse_options(char *optio
 		switch (token) {
 		case Opt_novrs:
 			uopt->novrs = 1;
+			break;
 		case Opt_bs:
 			if (match_int(&args[0], &option))
 				return 0;

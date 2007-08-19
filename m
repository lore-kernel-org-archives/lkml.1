Return-Path: <linux-kernel-owner+w=401wt.eu-S1754448AbXHSWR5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbXHSWR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 18:17:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXHSWRr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 18:17:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1483 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbXHSWRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 18:17:46 -0400
Subject: convert #include "linux/..." to #include <linux/...> [PATCH]s
	follow
From: Joe Perches <joe@perches.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@shadowen.org>
Content-Type: text/plain
Date: Sun, 19 Aug 2007 15:17:44 -0700
Message-Id: <1187561864.4200.136.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are several files that:

#include "linux/file" not #include <linux/file>
#include "asm/file" not #include <asm/file>

Here's a little script that converts them:

egrep -i -r -l --include=*.[ch] \
"^[[:space:]]*\#[[:space:]]*include[[:space:]]*\"(linux|asm)/(.*)\"" * \
| xargs sed -i -e 's/^[[:space:]]*#[[:space:]]*include[[:space:]]*"\(linux\|asm\)\/\(.*\)"/#include <\1\/\2>/g'

Maybe a similar check could be added to checkpatch.pl


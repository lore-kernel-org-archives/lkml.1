Return-Path: <linux-kernel-owner+w=401wt.eu-S1767810AbXCJEbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767810AbXCJEbl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767812AbXCJEbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:31:41 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33109 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767810AbXCJEbk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:31:40 -0500
Subject: [RFC PATCH 0/3] Fix module information when symbol_get is used
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: rusty@rustcorp.com.au
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       Rechberger Markus <mrechberger@gmail.com>,
       Linux DVB <linux-dvb@linuxtv.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 10 Mar 2007 02:31:22 -0200
Message-Id: <1173501083.26213.403.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

DVB code uses symbol_get/symbol_put functions at module.c to allow
dynamically add frontend modules (responsible for tuning and
demodulating the digital signal). The problem is that symbol_get doesn't
properly mark the module that requested it.

Trent worked on a fix for this, by using 3 patches. One on module.c,
another on mtd driver, and the last one on linux-dvb.

With the patch, lsmod produces output like this:
cx88_dvb               14084  0
or51132                 9988  1 cx88_dvb

Without it, this is what you get:
cx88_dvb               14084  0
or51132                 9988  1


 drivers/media/dvb/bt8xx/dst.c             |    5 -
 drivers/media/dvb/dvb-core/dvb_frontend.c |    9 +--
 drivers/mtd/chips/gen_probe.c             |    4 -
 include/linux/module.h                    |   13 ++--
 kernel/module.c                           |   87 ++++++++++++++++++++++--------
 5 files changed, 80 insertions(+), 38 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445Ab0CDGVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 01:21:23 -0500
Received: from mail.perches.com ([173.55.12.10]:1348 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0CDGVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 01:21:21 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundations.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Andrew <nick@nick-andrew.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Make functions of dev_<level> macros, recursive vsnprintf
Date: Wed,  3 Mar 2010 22:21:17 -0800
Message-Id: <cover.1267682641.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> macros use a lot of repetitive string space.

Eliminate the string prefixes and function arguments from all the macro uses
and consolidate them in functions.

This patchset saves about 60K.

This implementation also adds the ability to use a struct va_format to
emit a format string along with va_list arguments.

This %pV implementation should not be used without a wrapper that
does printf argument verification like the dev_<level> functions.

Inspired a bit by Nick Andrew's patches and Linus' comments in December 2008
http://lkml.org/lkml/2008/12/6/15
http://lkml.org/lkml/2008/12/6/101

Joe Perches (2):
  vsprintf: Recursive vsnprintf: Add "%pV", struct va_format
  device.h drivers/base/core.c Convert dev_<level> macros to functions

 drivers/base/core.c    |  124 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  102 +++++++++++++++++++++++++++++----------
 include/linux/kernel.h |    5 ++
 lib/vsprintf.c         |    9 ++++
 4 files changed, 214 insertions(+), 26 deletions(-)


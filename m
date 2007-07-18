Return-Path: <linux-kernel-owner+w=401wt.eu-S1762446AbXGRVJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446AbXGRVJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 17:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbXGRVIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 17:08:06 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:54055 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbXGRVIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 17:08:04 -0400
Subject: ia64 build failure from recent diskquota patch
From: Doug Chapman <doug.chapman@hp.com>
To: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       vtaras@openvz.org
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Jul 2007 17:03:19 -0400
Message-Id: <1184792599.3026.19.camel@deimos.americas.hpqcorp.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The commit: b716395e2b8e450e294537de0c91476ded2f0395 introduces a build
failure on ia64.

  CC      fs/quota.o
fs/quota.c:396: error: expected specifier-qualifier-list before ‘compat_u64’
fs/quota.c:409: error: expected specifier-qualifier-list before ‘compat_u64’
fs/quota.c:420: error: expected specifier-qualifier-list before ‘compat_uint_t’

.... more related errors ....


The type compat_u64 on ia64 is defined if CONFIG_COMPAT is defined
(which is rare these days on ia64)  So, it appears we are missing
an #ifdef CONFIG_COMPAT somewhere in fs/quota.c.  I will leave that
up to the original author to determine where.


- Doug



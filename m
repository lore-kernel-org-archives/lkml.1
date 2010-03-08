Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab0CHOAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 09:00:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab0CHOAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 09:00:05 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: kamezawa.hiroyu@jp.fujitsu.com, torvalds@osdl.org
cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: sync_mm_rss() issues
Date: Mon, 08 Mar 2010 13:59:56 +0000
Message-ID: <30859.1268056796@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are a couple of issues with sync_mm_rss(), as added by patch:

	commit 34e55232e59f7b19050267a05ff1226e5cd122a5
	Author: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
	Date:   Fri Mar 5 13:41:40 2010 -0800
	Subject: mm: avoid false sharing of mm_counter

 (1) You haven't implemented it for NOMMU mode.  What's the right way to do
     this?  Just give an empty function?

 (2) linux/mm.h should carry the empty function as an inline when
     CONFIG_SPLIT_RSS_COUNTING=n, rather than it being defined as an empty
     function in mm/memory.c.

David

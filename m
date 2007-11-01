Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbXKAQqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbXKAQqI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbXKAQp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:45:57 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:33721 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbXKAQp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:45:56 -0400
To: a.p.zijlstra@chello.nl
CC: jdike@addtoit.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: per-bdi-throttling: synchronous writepage doesn't work correctly
Message-Id: <E1IndEw-00046x-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 01 Nov 2007 17:49:54 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It looks like bdi_thresh will always be zero if filesystem does
synchronous writepage, resulting in very poor write performance.

Hostfs (UML) is one such example, but there might be others.

The only solution I can think of is to add a set_page_writeback();
end_page_writeback() pair (or some reduced variant, that only does
the proportions magic).  But that means auditing quite a few
filesystems...

Miklos

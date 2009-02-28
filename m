Return-Path: <linux-kernel-owner+w=401wt.eu-S1761505AbZB1Bxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505AbZB1Bxf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 20:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761885AbZB1Bv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 20:51:27 -0500
Received: from adsl-76-233-236-102.dsl.pltn13.sbcglobal.net ([76.233.236.102]:45524
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762934AbZB1Bv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 20:51:26 -0500
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Simple brk allocator for very early allocations
Date: Fri, 27 Feb 2009 17:51:17 -0800
Message-Id: <1235785882-17580-1-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series adds a very simple brk-like allocator for very early
allocations.  By default it extends the bss segment, starting at _end.

This is used to allocate x86-32's initial head_32.S pagetable, removing
init_pg_table_start/end and pg0, replacing them with brk allocations.

dmi_alloc() is also changed to use extend_brk.

	J

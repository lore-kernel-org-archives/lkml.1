Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbXHSNa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbXHSNa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 09:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbXHSNap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 09:30:45 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:42066 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbXHSNae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 09:30:34 -0400
Date: Sun, 19 Aug 2007 15:30:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [no patch] Remove more double inclusions
Message-ID: <Pine.LNX.4.64.0708191509320.6042@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,



Pipes for the world...

	find . -type f -iname "*.[ch]" -print0 | \
	xargs -0 grep -P '#\s*include' /dev/null | \
	sort | \
	uniq -c | \
	sort -gr | \
	less -MSi

turns up all the double-inclusions. Needs someone to review, because odd 
things like

	/* meh */

	#if defined(ABC)
	#	include "foo.h"
	#elif defined(DEF)
	#	include "foo.h"
	#else
	#	whatever
	#endif

are done. Or, that <foo.h> actually changes its meaning depending on a 
macro...

	/* ugly */

	#define FOO expand_me
	#include <foo.h>
	#undef FOO

	#define FOO something_else
	#include <foo.h>
	#undef FOO

happy hunting.


	Jan
-- 

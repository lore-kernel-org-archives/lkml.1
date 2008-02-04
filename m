Return-Path: <linux-kernel-owner+w=401wt.eu-S1755534AbYBDBtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534AbYBDBtf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 20:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754738AbYBDBt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 20:49:26 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:34906 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942AbYBDBtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 20:49:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NdacBLl1lilqbgf7OTllf1Ghy7Va6bD0c/PnMYa6qbPR89PLesSQ5jTm9WSVJ9ak8ZIcjG4oEIS6q4lmvPXphZObWReXOnPXtiaZYsHVokZ3FR068xRatsKv/pbjJ2wTtVUGYq8rhH7d1c/+fbkS4+4FxrzYgXJt7RJys6jbAE8=
Message-ID: <804dabb00802031749m7f0765f8q8cd1f6c6a881651c@mail.gmail.com>
Date: Mon, 4 Feb 2008 09:49:24 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Coexistence of EXPORT_SYMBOL() and __cpuinit
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In kernel/cpu.c, there exists API that is declared as __cpuinit, and
at the same time exported via EXPORT_SYMBOL().

Can these two attribute coexists at the same time?   I mean, when it
is declared with EXPORT_SYMBOL, according to include/linux/module.h,
it is placed in a __ksymtab section, and when compiled with with
__cpuinit, according to include/linux/init.h, into a __cpuinit
section.

Can gcc compiled ELF support this feature?

Anyway, logical speaking, if it is EXPORT_SYMBOL, it is meant to be
long-lasting, and not short-live as __cpuinit is meant to be, right?

Please comment, thanks.

If ok, I will modify the cpu.c to remove all the __cpuinit whenever
EXPORT_SYMBOL is encountered for it (or any __init in general :-)).

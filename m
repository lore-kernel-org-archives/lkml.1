Return-Path: <linux-kernel-owner+w=401wt.eu-S1756655AbZGGLVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655AbZGGLVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755924AbZGGLVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:21:16 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:6816 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbZGGLVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:21:15 -0400
Date: 07 Jul 2009 13:21:11 +0200
From: krzysztof.h1@poczta.fm
Subject: Please revert 4148df9b0f38bdd362dd91d52076926c11cbe5a9
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
MIME-Version: 1.0
Content-Type: TEXT/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-ORIGINATE-IP: 83.17.101.58
IMPORTANCE: Normal
X-MSMAIL-PRIORITY: Normal
X-PRIORITY: 3
X-Mailer: PSE3
Message-Id: <20090707112112.6D66F216C3A@f52.poczta.interia.pl>
X-EMID: bf340acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please revert the commit 4148df9b0f38bdd362dd91d52076926c11cbe5a9 "fb: Initialize fb_info mutexes in framebuffer_alloc()".

At this point it does not fix any bug since all four affected drivers (sisfb, matroxfb, sm501fb and mx3fb) are fixed by now.

This commit breaks all drivers which do not allocate fb_info structure dynamically and there are about 10 of such drivers. This is perfectly valid for devices with built-in single framebuffer controller without ability to attach something else (e.g pxafb is an affected by the commit). Fixing some of these drivers requires heavy rewriting for the ones like matroxfb and pxafb.

An alternate patch to fix the issue with the sm501fb has been posted here for Paul to test:

http://patchwork.kernel.org/patch/34165/

This patch is a better way to fix the issue as it makes the code shorter and faster start of the framebuffer. However, the previous Paul's fix to the sm501fb is enough and this patch is a proposition for him.

Regards,
Krzysztof

----------------------------------------------------------------------
Wybierz najlepsze ubezpieczenie komunikacyjne.
http://link.interia.pl/f222d


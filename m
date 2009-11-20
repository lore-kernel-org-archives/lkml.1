Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZKTN33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZKTN33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 08:29:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZKTN33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 08:29:29 -0500
Received: from nox.protox.org ([88.191.38.29]:47407 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbZKTN32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 08:29:28 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org
Subject: 
Date: Fri, 20 Nov 2009 14:29:21 +0100
Message-Id: <1258723764-4399-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series add ttm range validation function. Aim is to
include this in 2.6.33 so i have time to iron out issue, comments.

ttm:
I duplicated a bunch of ttm functions but now i think, best would
be to add range to all function and use free list if range cover
all the manager space. Doing so we might also be able to simplify
mem_space alocation into a simpler function like ttm_bo_mem_space_range

radeon:
The second patch is a rework/cleanup of radeon object, it solves
few issues along the way (i can't remember them now after fews
days testing the patches). Biggest change is that we now rely
on BO being validated before doing any change to radeon bo structure.
As with any big patch i might introduce regressions, so far after
testing on AGP:R1XX,R2XX,R3XX,R6XX PCIE:R3XX,R4XX,R5XX,R6XX,R7XX
and RS480,RS690 i didn't found anythings obvious (test being X +
glxgears + compiz(on hw which support it) + suspend/resume).

Last patch is smaller, it just use the interface introduced by
the first patch.


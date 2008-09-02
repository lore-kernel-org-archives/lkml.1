Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbYIBNtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbYIBNtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 09:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbYIBNt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 09:49:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56424 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYIBNt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 09:49:26 -0400
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20080902349.573187695@firstfloor.org>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/2] Fix panic regression in 2.6.27
Date: Tue,  2 Sep 2008 15:49:21 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


panic() from an interrupt right now spews lots of ugly WARN_ON
warnings because panic->smp_send_stop calls the new smp
call helpers which complain on irqs_disabled().

I fixed it in two parts: add a new SYSTEM_PANIC state to check
cleanly for panic and then disable the warnings in this case.

I believe this should be fixed for 2.6.27.

-Andi

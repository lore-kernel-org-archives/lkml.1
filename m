Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbYLVLpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbYLVLpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 06:45:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbYLVLpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 06:45:32 -0500
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:33870 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbYLVLpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 06:45:31 -0500
Message-Id: <20081222113629.080104676@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Mon, 22 Dec 2008 12:36:29 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 0/2] stop_machine: create kstop threads only when needed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce stop_machine_create/destroy. With this interface subsystems
that need a non-failing stop_machine environment can create the
stop_machine threads before actually calling stop_machine.
When the threads aren't needed anymore they can be killed with
stop_machine_destroy again.

When stop_machine gets called and the threads aren't present they
will be created and destroyed automatically.

This restores the old behaviour of stop_machine from 2.6.27 and thus
we get rid of the normally not needed kstop threads.

The second patch converts the module loader/unloder code to the new
interface, since it needs a non-failing stop_machine infrastructure.

Looks like there are more users that need a non-failing version.
I'll take care of them when I'm back from vacation.

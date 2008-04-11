Return-Path: <linux-kernel-owner+w=401wt.eu-S1760666AbYDKQUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760666AbYDKQUa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 12:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759893AbYDKQUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 12:20:21 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34079 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759113AbYDKQUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 12:20:20 -0400
Message-Id: <20080411161702.460410000@bull.net>
User-Agent: quilt/0.45-1
Date: Fri, 11 Apr 2008 18:17:02 +0200
From: Nadia.Derbey@bull.net
To: efault@gmx.de
Cc: manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
       peterz@infradead.org, xemul@openvz.org
Subject: [PATCH 00/13] Re: Scalability requirements for sysv ipc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Here is finally the ipc ridr-based implementation I was talking about last
week (see http://lkml.org/lkml/2008/4/4/208).
I couldn't avoid much of the code duplication, but at least made things
incremental.

Does somebody now a test suite that exists for the idr API, that I could
run on this new api?

Mike, can you try to run it on your victim: I had such a hard time building
this patch, that I couldn't re-run the test on my 8-core with this new
version. So the last results I have are for 2.6.25-rc3-mm1.

Also, I think a careful review should be done to avoid introducing yet other
problems :-(

*WARNING*: this patch contains a fix for idr.c
           I know, I'm doing things bad, but I only saw the problem this
           afternoon.

It should be applied on linux-2.6.25-rc8-mm1, in the following order:

[ PATCH 01/13 ] : copy_idr_code.patch
[ PATCH 02/13 ] : change_ridr_struct.patch
[ PATCH 03/13 ] : ridr_pre_get.patch
[ PATCH 04/13 ] : ridr_alloc_layer.patch
[ PATCH 05/13 ] : ridr_free_layer.patch
[ PATCH 06/13 ] : ridr_sub_alloc.patch
[ PATCH 07/13 ] : ridr_get_empty_slot.patch
[ PATCH 08/13 ] : ridr_get_new.patch
[ PATCH 09/13 ] : ridr_remove.patch
[ PATCH 10/13 ] : ridr_find.patch
[ PATCH 11/13 ] : ridr_integrate.patch
[ PATCH 12/13 ] : ipc_use_ridr.patch
[ PATCH 13/13 ] : remove_ipc_lock_down.patch

Regards,
Nadia

--

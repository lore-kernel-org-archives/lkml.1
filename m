Return-Path: <linux-kernel-owner+w=401wt.eu-S1751149AbXDMBxC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751149AbXDMBxC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 21:53:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXDMBxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 21:53:01 -0400
Received: from dougfood.mirapoint.com ([63.107.133.21]:40631 "EHLO
	dougfood.mirapoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXDMBxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 21:53:00 -0400
From: <mchu@mirapoint.com>
Subject: Cheap lock for user mode processes release
 when process exits
To: <linux-kernel@vger.kernel.org>
X-Mailer: Mirapoint Webmail Direct 4.0.0.6-L
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20070413015428.AMJ80009@dougfood.mirapoint.com>
Date: Fri, 13 Apr 2007 01:54:28 +0000 (GMT)
X-Junkmail-Whitelist: YES (by domain whitelist at dougfood.mirapoint.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Maybe someone here knows better.

I have several user-mode processes using shared mmap.  There can be several reader processes and only one writer.  Readers access the shared region frequently, writer seldom.

Naturally, multi-reader/single-writer locks works best.  I tried this with futex on 2.6.9-42.EL.  However, if one of the processes is killed/exits, the lock doesn't get released.

I can trap the signal to release the lock, but not all signals like kill.

Anyway I can achieve this without a potential deadlock?

Thanks,
Michael

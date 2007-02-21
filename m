Return-Path: <linux-kernel-owner+w=401wt.eu-S1751146AbXBUG5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbXBUG5M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 01:57:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXBUG5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 01:57:12 -0500
Received: from wx-out-0506.google.com ([66.249.82.233]:50281 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbXBUG5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 01:57:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Q8lQXVQUe4PmV9bi85wehuCGUop3RK7oEwkB+IGf0R/8kvVqoqgxRNJdIdJJd7Ida4nL74h0Z5bYq/vAvEhTmncUXdmCDLArgY1dcWXCbT8I0WhN0St92r2VDpCHweH6154v5KeXkmMX1lixAnzRxDa6S6sEmg8aSKSnN55bkIA=
Message-ID: <a44ae5cd0702202257g28a6ccb4rc89d45b90bc6bec4@mail.gmail.com>
Date: Tue, 20 Feb 2007 22:57:09 -0800
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       "Alex Dubov" <oakad@yahoo.com>
Subject: 2.6.20-mm2 -- tifm/0/1919 is trying to release lock (&fm->lock) at: [<f90d392f>] tifm_7xx1_switch_media+0x2e9/0x326 [tifm_7xx1]
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When I pull my SD card out of my laptop, I get the following:

tifm_7xx1: demand removing card from socket 3
=====================================
[ BUG: bad unlock balance detected! ]
-------------------------------------
tifm/0/1919 is trying to release lock (&fm->lock) at:
[<f90d392f>] tifm_7xx1_switch_media+0x2e9/0x326 [tifm_7xx1]
but there are no more locks to release!

other info that might help us debug this:
no locks held by tifm/0/1919.

stack backtrace:
 [<c0104c86>] show_trace_log_lvl+0x1a/0x2f
 [<c01052ba>] show_trace+0x12/0x14
 [<c010533e>] dump_stack+0x16/0x18
 [<c0130c8f>] print_unlock_inbalance_bug+0xec/0xf9
 [<c0132dd5>] lock_release+0x9b/0x17c
 [<c02fcb48>] _spin_unlock_irqrestore+0x19/0x3c
 [<f90d392f>] tifm_7xx1_switch_media+0x2e9/0x326 [tifm_7xx1]
 [<c0128cf4>] kthread+0xa3/0xcf
 [<c0104937>] kernel_thread_helper+0x7/0x10

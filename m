Return-Path: <linux-kernel-owner+w=401wt.eu-S1756489AbXKTKbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489AbXKTKbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 05:31:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbXKTKbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 05:31:45 -0500
Received: from mail1.topsec.com.cn ([202.99.27.222]:65312 "EHLO
	mail1.topsec.com.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbXKTKbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 05:31:45 -0500
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2007 05:31:45 EST
Message-Id: <200711201028.AYF43414@topsec.com.cn>
From: <wyb@topsec.com.cn>
To: <linux-kernel@vger.kernel.org>
Subject: is it useful testing __LINK_STATE_RX_SCHED in dev_close()?
Date: Tue, 20 Nov 2007 18:26:26 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AcgrX85zSnBhocidQPK1/poeV/lclg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cpu0 calling netif_rx_schedule_prep(), cpu1 calling dev_close():

cpu0: testing __LINK_STATE_START, already set
cpu1: clear__LINK_STATE_START
cpu1: testing __LINK_STATE_RX_SCHED, not set
cpu0: set __LINK_STATE_RX_SCHED
cpu0: enter net poll, ...

when cpu1 return from dev_close(),__LINK_STATE_RX_SCHED is still set.



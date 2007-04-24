Return-Path: <linux-kernel-owner+w=401wt.eu-S1161509AbXDXWBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161509AbXDXWBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 18:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161172AbXDXWBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 18:01:52 -0400
Received: from gherkin.frus.com ([192.158.254.49]:45682 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161023AbXDXWBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 18:01:51 -0400
Subject: old ISA DMA bug in 2.6.12?
To: linux-kernel@vger.kernel.org
Date: Tue, 24 Apr 2007 17:01:46 -0500 (CDT)
CC: linux-scsi@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070424220146.2EA64DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was enjoying yet another session of beating my head against the wall
trying to do useful things with old hardware :-), and managed to cause a
kernel panic by simply trying to mount a cdrom in the context of a DSL-N
installation.

The SCSI host adapter is an Adaptec AHA-1542B, and when I try to mount a
cdrom, I manage to run afoul of the BAD_DMA() check in aha1542.c: the
buffer returned is not in the lower 16 MB of memory.

The same 2.6.12 kernel + hardware combination works fine as long as I
confine my I/O to the hard disk that's also attached to the AHA-1542B.

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------

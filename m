Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbZEZPWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbZEZPWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 11:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754759AbZEZPWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 11:22:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51607 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754681AbZEZPWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 11:22:35 -0400
Date: Tue, 26 May 2009 11:22:36 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Arjan van de Ven <arjan@linux.intel.com>
cc: SCSI development list <linux-scsi@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Bug in SCSI async probing
Message-ID: <Pine.LNX.4.44L0.0905261040230.5554-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James & Arjan:

Am I missing something here?  It looks like

	fastboot: make scsi probes asynchronous

has introduced a bug in the sd probing code.  AFAICT, there is now
nothing to prevent do_scan_async() from returning before
sd_probe_async() has run.

Doesn't this mean that there's nothing to prevent sd_remove() from 
being called and trying to unregister the disk _before_ 
sd_probe_async() has managed to register it?

Alan Stern


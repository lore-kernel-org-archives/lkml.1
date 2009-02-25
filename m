Return-Path: <linux-kernel-owner+w=401wt.eu-S1762249AbZBYWZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762249AbZBYWZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 17:25:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757116AbZBYWZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 17:25:01 -0500
Received: from smtp-noauth7.primus.ca ([216.254.180.38]:43820 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751045AbZBYWZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 17:25:01 -0500
From: Matthew Wilcox <matthew@wil.cx>
To: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: ATA support for 4k sector size
Date: Wed, 25 Feb 2009 17:24:56 -0500
Message-Id: <1235600698-6446-1-git-send-email-matthew@wil.cx>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The two patches following this add support for drives which have sector
sizes other than 512 bytes.  I haven't been able to test this as I don't
have the hardware.

Individual host drivers will have to be updated to support sizes other
than 512 bytes.

Support for logical sector sizes that differ from physical sector sizes
depends on the READ CAPACITY 16 patch I posted in December that isn't in
scsi-misc yet.

The approach I've taken to generating the tables of which commands need
a 512-byte transfer size and which use the drive's sector size command is
'innovative'.  Review is encouraged ;-)

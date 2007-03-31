Return-Path: <linux-kernel-owner+w=401wt.eu-S1753878AbXCaSqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbXCaSqc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 14:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbXCaSqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 14:46:32 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:40335 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753824AbXCaSqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 14:46:31 -0400
Subject: Re: [PATCH 3/4] [SCSI]stex: fix reset recovery for console device
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>,
       promise_linux <promise_linux@promise.com>
In-Reply-To: <NONAMEB98KtdhQYZkxO000005d5@nonameb.ptu.promise.com>
References: <NONAMEB98KtdhQYZkxO000005d5@nonameb.ptu.promise.com>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 13:46:27 -0500
Message-Id: <1175366787.3760.68.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-30 at 15:21 -0700, Ed Lin wrote:
> After reset completed, the scsi error handler sends out START_STOP
> and TEST_UNIT_READY to the device. For 'normal' devices these
> commands will be handled by firmware. However, because the RAID
> console only interfaces to scsi mid layer, the firmware will not process
> these commands for it. This will make the console to be offlined right
> after reset. Add the handling in driver to fix this problem.

I don't see how this explanation can be correct.  The error handler only
sends a START_STOP command if sdev->allow_restart is one, which you have
to set in the slave_configure routines (which stex doesn't).  If you're
seeing a START_STOP in the eh path, there's something else wrong.
TEST_UNIT_READY, certainly ... it's part of a restart check.

James



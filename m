Return-Path: <linux-kernel-owner+w=401wt.eu-S933036AbXC0Qef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933036AbXC0Qef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933092AbXC0Qef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:34:35 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:59059 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933036AbXC0Qed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:34:33 -0400
Subject: Re: CONFIG_SCSI_WAIT_SCAN=m
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0703271658380.26754@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0703271658380.26754@blonde.wat.veritas.com>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 11:34:17 -0500
Message-Id: <1175013257.3737.21.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-27 at 17:25 +0100, Hugh Dickins wrote:
> I'm not using an initrd, most of my kernel is builtin,
> just a few modules for occasional filesystems.
> 
> CONFIG_MODULES=y
> CONFIG_SCSI=y
> CONFIG_SCSI_SCAN_ASYNC=y
> CONFIG_SCSI_WAIT_SCAN=m
> 
> 2.6.21-rc5-mm2 VFS panics unable to find my root on /dev/sda2,
> but boots okay if I change drivers/scsi/Kconfig to "default y"
> instead of "default m" for SCSI_WAIT_SCAN.

Hmm ... it sounds like there's a missing scsi_complete_async_scans() in
your environment?  What's your configuration ... which SCSI drivers, and
which are modules?

scsi_wait_async_scan is supposed to be unnecessary unless you have
modular SCSI drivers that the initrd needs to wait for root on.

James



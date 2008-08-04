Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYHDPUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYHDPUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 11:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbYHDPUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 11:20:10 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:52880 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbYHDPUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 11:20:08 -0400
X-IronPort-AV: E=Sophos;i="4.31,304,1215388800"; 
   d="scan'208";a="1277309"
Date: Mon, 4 Aug 2008 16:20:02 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org
Subject: Re: ext3 seems to ignore ECC errors
Message-ID: <20080804152002.GT4470@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org
References: <20080804150353.GS4470@implementation.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080804150353.GS4470@implementation.uk.xensource.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-OriginalArrivalTime: 04 Aug 2008 15:20:07.0687 (UTC) FILETIME=[94094170:01C8F645]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Mon 04 Aug 2008 16:03:53 +0100, a écrit :
> However, to my surprise Linux (2.6.26) continued to mount the ext3
> filesystem read/write, spitting out a lot of IDE errors.

Note: these look like

hdb: dma_intr: status=0x41 { DriveReady Error }
hdb: dma_intr: error=0x44 { DriveStatusError UncorrectableError }, LBAsect=1189689234687, sector=70911
ide: failed opcode was: unknown
end_request: I/O/error, dev hdb sector 70911
Buffer I/O error on device hdb1, logical block 8856
lost page write due to I/O error on hdb1
etc.

So it seems the error is properly reported up to the filesystem
((70911-63) * 512 / 4096 == 8856)

Samuel

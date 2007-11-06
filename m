Return-Path: <linux-kernel-owner+w=401wt.eu-S1754805AbXKFWuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbXKFWuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 17:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755093AbXKFWuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 17:50:16 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59827 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbXKFWuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 17:50:15 -0500
Date: Tue, 6 Nov 2007 22:50:12 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix writing to unintended memory in pkt_generic_packet(); drivers/block/pktcdvd.c
Message-ID: <20071106225012.GK8181@ftp.linux.org.uk>
References: <4730EE00.8040809@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4730EE00.8040809@tiscali.nl>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 11:43:12PM +0100, Roel Kluin wrote:
> CDROM_PACKET_SIZE is added as an offset to the pointer to unsigned char cmd[16].
> The adjusted pointer is then used as a destination address in a call to
> memset(). However, when CDROM_PACKET_SIZE is added to the pointer, it is
> automatically scaled by the size of cmd, which is 16. This results in the call
> to memset() writing to unintended memory.

What are you talking about?  rq->cmd is an array, not a pointer to array.
When it occurs as an argument of +, it decays to pointer to array element.
Please, learn C.

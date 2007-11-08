Return-Path: <linux-kernel-owner+w=401wt.eu-S1762235AbXKHWdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762235AbXKHWdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 17:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760070AbXKHWdW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 17:33:22 -0500
Received: from lazybastard.de ([212.112.238.170]:51974 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760121AbXKHWdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 17:33:21 -0500
Date: Thu, 8 Nov 2007 23:28:24 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Przemyslaw Wegrzyn <czajnik@czajsoft.pl>
Cc: linux-kernel@vger.kernel.org, Steve French <smfrench@austin.rr.com>
Subject: Re: Buffer overflow in CIFS VFS.
Message-ID: <20071108222824.GD18903@lazybastard.org>
References: <47337D83.5040706@czajsoft.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47337D83.5040706@czajsoft.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not everyone has the time to read lkml.  Added Steve to Cc:, just in
case.

On Thu, 8 November 2007 22:20:03 +0100, Przemyslaw Wegrzyn wrote:
> 
> I was looking at CIFS VFS code recently, trying to solve other issue,
> just to find something that looks like a buffer overflow  bug.
> The problem is in SendReceive() function in transport.c - it memcpy's
> message payload into a buffer passed via out_buf param. The function
> assumes that all buffers are of size (CIFSMaxBufSize +
> MAX_CIFS_HDR_SIZE) , unfortunately it is also called with smaller
> (MAX_CIFS_SMALL_BUFFER_SIZE) buffers.
> 
> To check this finding I patched Samba server to send oversized logoffX
> messages. With ~ 16kB messages the client running 2.6.23.1 crashed upon
> unmounting.
> 
> I've done a quick fix, available here:
> http://czajnick.sitenet.pl/cifs-buffer-overflow-fix.patch.gz

Jörn

-- 
When in doubt, punt.  When somebody actually complains, go back and fix it...
The 90% solution is a good thing.
-- Rob Landley

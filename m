Return-Path: <linux-kernel-owner+w=401wt.eu-S1760725AbYKVRof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760725AbYKVRof (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759356AbYKVRoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:44:16 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54573 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760204AbYKVRoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:44:14 -0500
Date: Sat, 22 Nov 2008 11:44:06 -0600
From: Andreas Dilger <adilger@sun.com>
Subject: Re: Zero-clearing all zero-clearable bytes.
In-reply-to: <200811221236.FJE81778.LtMHOQFJFVFSOO@I-love.SAKURA.ne.jp>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <20081122174406.GQ3186@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <200811221236.FJE81778.LtMHOQFJFVFSOO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 22, 2008  12:36 +0900, Tetsuo Handa wrote:
> Compressing whole image files includes compressing deleted/unused bytes within
> a block. This means that non-zero bytes in deleted/unused blocks affect
> compression ratio.
> 
>     static char buffer[4096];
>     memset(buffer, 0, sizeof(buffer));
>     snprintf(buffer, sizeof(buffer) - 1, "%s/XXXXXX", argc > 1 ? argv[1] : "");
>     if ((fd = mkstemp(buffer)) != EOF) {
>         unlink(buffer);
>         memset(buffer, 255, sizeof(buffer));
>         while (write(fd, buffer, sizeof(buffer)) > 0);

Why would you fill the buffer with 0xff instead of 0?
In fact no such program is needed, just "dd if=/dev/zero of=/{fs}/tmp"
and then delete the file.


Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.


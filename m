Return-Path: <linux-kernel-owner+w=401wt.eu-S1030293AbXDKTs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293AbXDKTs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030283AbXDKTsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:48:25 -0400
Received: from 1wt.eu ([62.212.114.60]:1757 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030293AbXDKTsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:48:25 -0400
Date: Wed, 11 Apr 2007 21:48:20 +0200
From: Willy Tarreau <w@1wt.eu>
To: Pedro <linux_user@izecksohn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer
Message-ID: <20070411194820.GI943@1wt.eu>
References: <200704110223.31291.linux_user@izecksohn.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704110223.31291.linux_user@izecksohn.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2007 at 02:23:31AM -0300, Pedro wrote:
>   After suffering some days from a not|mis configured tmpfs,
> 
>   As the OOM killer is not Posix,
> 
>   Better than to kill processes would be to resize tmpfs, to use tmpfs empty 
> space.

Will not work, because tmpfs does not use any memory for unused space. If
you don't believe me, simply create a large file on your tmpfs, then check
free memory, then remove the file and check free memory again.

So your problem is not caused by the empty space on tmpfs, but either by
too much space used on tmpfs or by your application using too much memory.

>   I'm using kernel 2.6.20.4. If someone ask I'll send a test application.

Not needed, the one-liner "main(){while(malloc(4096));}" is enough to
trigger an OOM.

If you cannot control your application's memory usage, you'll have to finely
tune the overcommit_ratio.

Regards,
Willy


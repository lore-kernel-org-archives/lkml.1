Return-Path: <linux-kernel-owner+w=401wt.eu-S1762809AbXEWAJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762809AbXEWAJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758800AbXEWAIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:08:40 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:41014 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758287AbXEWAIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:08:36 -0400
Date: Mon, 21 May 2007 23:37:30 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Bryan Wu <bryan.wu@analog.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/32] Blackfin update for 2.6.22-rc2
Message-ID: <20070521143730.GA18110@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	Bryan Wu <bryan.wu@analog.com>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <1179742180228-git-send-email-bryan.wu@analog.com> <200705211035.08380.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705211035.08380.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2007 at 10:35:08AM -0400, Robin Getz wrote:
> On Mon 21 May 2007 06:09, Bryan Wu pondered:
> > Lots of update for 2.6.22-rc2 and tested on STAMP537 board.
> >
> 
> One of the things I noticed when trying out 2.6.22-rc1, on blackfin was:
> 
>  CALL    scripts/checksyscalls.sh
[snip syscalls]
> 
> since there is noMMU, are we better:
>  - putting stubs (return ENOSYS - give runtime errors), or 
>  - just ignore the errors - and give compile errors? (Is there any way to put 
> something into the syscall table, as not to get the warnings?)
> 
No, you'd be better of figuring out which ones you can support and which
ones you have to -ENOSYS. CONFIG_MMU=n is not a "get out of syscalls
free" card. Many of these have no dependency on CONFIG_MMU, anyways.

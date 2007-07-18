Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbXGRUQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbXGRUQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750925AbXGRUQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:16:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39471 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752640AbXGRUQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:16:18 -0400
Date: Wed, 18 Jul 2007 13:15:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn/sc: compile breakage re check_reset()
Message-Id: <20070718131502.d54477ea.akpm@linux-foundation.org>
In-Reply-To: <20070717103343.GA25083@localhost.sw.ru>
References: <20070717103343.GA25083@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 14:33:43 +0400
Alexey Dobriyan <adobriyan@sw.ru> wrote:

> There is check_reset() -- global function in drivers/isdn/sc/
> There is check_reset -- variable holding module param in aacraid driver.
> 
> On allyesconfig they clash with:
> 
>   LD      drivers/built-in.o
> drivers/isdn/built-in.o: In function `check_reset':
> : multiple definition of `check_reset'
> drivers/scsi/built-in.o:(.data+0xe458): first defined here
> ld: Warning: size of symbol `check_reset' changed from 4 in drivers/scsi/built-in.o to 219 in drivers/isdn/built-in.o
> ld: Warning: type of symbol `check_reset' changed from 1 to 2 in drivers/isdn/built-in.o
> 
> Rename the former.

yeah, well, I did aacraid-rename-check_reset.patch last month, but scsi
patches are hard to get rid of.

Both patches are needed: check_reset() is a dopey name.

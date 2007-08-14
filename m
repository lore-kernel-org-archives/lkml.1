Return-Path: <linux-kernel-owner+w=401wt.eu-S937995AbXHNFCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937995AbXHNFCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757374AbXHNFCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:02:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52344 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755502AbXHNFC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:02:29 -0400
Date: Mon, 13 Aug 2007 22:01:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@redhat.com>
Subject: Re: [PATCH] fix NULL pointer dereference in __vm_enough_memory()
Message-Id: <20070813220142.99e46091.akpm@linux-foundation.org>
In-Reply-To: <20070813140106.23b93ff5@the-village.bc.nu>
References: <20070812141905.4ee423b9@the-village.bc.nu>
	<386927758.14086@ustc.edu.cn>
	<20070812161744.200d4252@the-village.bc.nu>
	<386990734.21206@ustc.edu.cn>
	<20070813140106.23b93ff5@the-village.bc.nu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Aug 2007 14:01:06 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Mon, 13 Aug 2007 15:38:53 +0800
> WU Fengguang <wfg@mail.ustc.edu.cn> wrote:
> 
> > On Sun, Aug 12, 2007 at 04:17:44PM +0100, Alan Cox wrote:
> > > Try this (it compiles but isnt tested). Its a weekend here, the sun is
> > > shining, the beach is a short walk, and I have more interesting things to
> > > do right now 8)
> > 
> > Have a nice day~~~ It works!
> 
> Ok please apply the patch then Andrew
> 
> ---
> 
> The new exec code inserts an accounted vma into an mm struct which is not
> current->mm. The existing memory check code has a hard coded assumption
> that this does not happen as does the security code.
> 
> As the correct mm is known we pass the mm to the security method and the
> helper function. A new security test is added for the case where we need
> to pass the mm and the existing one is modified to pass current->mm to
> avoid the need to change large amounts of code.
> 
> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/include/linux/mm.h linux-2.6.23rc1-mm1/include/linux/mm.h
> --- linux.vanilla-2.6.23rc1-mm1/include/linux/mm.h	2007-07-26 15:02:58.000000000 +0100

erp, we have major version skew between 2.6.23-rc1-mm1 and 2.6.23-rc3 here, sorry.

Could I ask for a redone patch against mainline?

Thanks.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756405AbXGCA2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405AbXGCA2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 20:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757700AbXGCA2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 20:28:30 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:8117 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634AbXGCA2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 20:28:14 -0400
X-IronPort-AV: i="4.16,489,1175486400"; 
   d="scan'208"; a="33932957:sNHT25540802"
Subject: Re: why does git perpetually complain about
	include/asm-blackfin/macros.h?
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Marco Roeland <marco.roeland@xs4all.nl>
Cc: Jesper Juhl <jesper.juhl@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070702142430.GA10400@fiberbit.xs4all.nl>
References: <Pine.LNX.4.64.0707020800010.1972@localhost.localdomain>
	 <4688EF9B.8020405@garzik.org>
	 <9a8748490707020658t5e6542ag6edb435dbc4499ab@mail.gmail.com>
	 <20070702142430.GA10400@fiberbit.xs4all.nl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Tue, 03 Jul 2007 08:28:09 +0800
Message-Id: <1183422489.10353.2.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 03 Jul 2007 00:28:12.0790 (UTC) FILETIME=[0A438160:01C7BD09]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-02 at 16:24 +0200, Marco Roeland wrote:
> On Monday July 2nd 2007 at 15:58 Jesper Juhl wrote:
> 
> > [obnoxious zero sized file include/asm-blackfin/macros.h that gets
> >  zapped by toolchains and resurrected again by git]
> >
> > I've seen that as well, but in my case doing a
> > $ git reset --hard master
> > fixed it.
> 
> Dangerous, as it may overwrite local changes you have! A simple "git
> checkout include/asm-blackfin/macros.h" is much safer in this case.
> 
> In git commit df30b11 this file got redundant. Perhaps because a normal
> patch was applied, instead of with git, the file didn't get deleted from
> the repository but truncated to size zero. Not strictly wrong perse, but
> for the Linux repository highly unusual (and the only one at that).
> 
> Your toolchain perhaps deletes files with zero size after cleaning up or
> something. Git then notices that you deleted this file.
> 
> Perhaps someone can apply something like the following to finally fix
> this up:
> 
> commit 7d98740800f3d9ad2428afa8c677be9573a51b7b
> Author: Marco Roeland <marco.roeland@xs4all.nl>
> Date:   Mon Jul 2 16:19:49 2007 +0200
> 
>     Blackfin arch: remove zero-sized include/asm-blackfin/macros.h
>     
>     This file accidentally got truncated instead of deleted in commit df30b11.
>     
>     Signed-off-by: Marco Roeland <marco.roeland@xs4all.nl>
> 
> diff --git a/include/asm-blackfin/macros.h b/include/asm-blackfin/macros.h
> deleted file mode 100644
> index e69de29..0000000
> -

Thanks, Applied to the blackfin-2.6.git tree for Linus pull.

- Bryan

> To unsubscribe from this list: send the line "unsubscribe git" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

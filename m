Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab0BJPC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 10:02:26 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49224 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab0BJPCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:02:25 -0500
To: Tejun Heo <tj@kernel.org>
CC: miklos@szeredi.hu, mszeredi@suse.cz, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, polynomial-c@gentoo.org,
       akpm@linux-foundation.org
In-reply-to: <4B72A802.6040009@kernel.org> (message from Tejun Heo on Wed, 10
	Feb 2010 21:35:14 +0900)
Subject: Re: [fuse-devel] [PATCH] FUSE/CUSE: implement direct mmap support
References: <4B70FBE4.7050700@kernel.org> <E1NerZ6-0007N6-UY@pomaz-ex.szeredi.hu> <4B7296DF.207@kernel.org> <E1NfAl6-0000o4-8Z@pomaz-ex.szeredi.hu> <4B729F07.8020704@kernel.org> <E1NfBTc-0000vk-59@pomaz-ex.szeredi.hu> <4B72A802.6040009@kernel.org>
Message-Id: <E1NfE50-0001EK-Ao@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 10 Feb 2010 16:02:14 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Feb 2010, Tejun Heo wrote:
> > When does that happen?  Can it happen that two mappings of the same
> > file descriptor will have different backing pages?
> 
> Yeah, sure.  FUSE server is free to give them separate regions.  The
> only restriction is the SHMLBA alignment which is pretty easy to
> adhere to.

What I really meant was: does it ever happen that mapping a *single
open file* of a chardev twice will result in two different maps?
Or will the maps be only different if it was a different open of the
device?

If there's a pattern there, we might make the sharing/non-sharing
automated, and greatly simplify the interface.

Thanks,
Miklos

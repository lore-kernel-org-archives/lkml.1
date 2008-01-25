Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbYAYJYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbYAYJYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 04:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbYAYJYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 04:24:24 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:32893 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296AbYAYJYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 04:24:22 -0500
To: hpa@zytor.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <4798EB07.50002@zytor.com> (hpa@zytor.com)
Subject: Re: [patch 10/26] mount options: fix devpts
References: <20080124193341.166753833@szeredi.hu> <20080124193429.480166399@szeredi.hu> <4798EB07.50002@zytor.com>
Message-Id: <E1JIKn4-0001Jb-Vo@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 25 Jan 2008 10:24:02 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Also add minor fix: when parsing the "mode" option, mask with
> > S_IALLUGO instead of ~S_IFMT, which could leave unsed bits in the
> > mask.
> 
> umode_t is 16 bits, so it doesn't.  The change is still good, of course.

We still use 16 bit types?  Strange ;)

> 
> > +	if (config.mode != DEVPTS_DEFAULT_MODE)
> > +		seq_printf(seq, ",mode=%03o", config.mode);
> 
> I would rather this be unconditional, than that it be conditional on 
> something other than the user having specified it in the first place.

Yeah, it's a matter of taste.  I'll update the patch.

Actually, a lot of filesystems share the options 'uid=X', 'gid=X',
'mode=X' (or 'umask=X').  This could be handled by the VFS, saving
some code, and making things more consistent.  One day maybe...

Thanks,
Miklos

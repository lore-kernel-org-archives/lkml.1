Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbYBWKBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbYBWKBT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 05:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYBWKBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 05:01:06 -0500
Received: from qb-out-0506.google.com ([72.14.204.225]:10849 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748AbYBWKBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 05:01:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=IEegcmt8Gf44COWXm4Npu8Vn0TSHN2CFIWl0IsUeRnCa0RbQQBHJsa7vKPvFtjbQKDc/Ef0e2ujIsxgAeNMd/61rXj6qRteMUS+He7OOX2ROD5XOl1PVp15INlB3quHEv3aFucybNY8sC785BOUC0AAejsq+2Yly2Vz4zKDfPVc=
Date: Sat, 23 Feb 2008 17:56:09 +0800 (CST)
Message-Id: <20080223.175609.11999385.xiyou.wangcong@gmail.com>
To: adobriyan@gmail.com
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/16] (Resend) Use get_personality()
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080223092710.GD2262@martell.zuzino.mipt.ru>
References: <20080223085101.GC2262@martell.zuzino.mipt.ru>
	<20080223.165944.37229792.xiyou.wangcong@gmail.com>
	<20080223092710.GD2262@martell.zuzino.mipt.ru>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 00/16] (Resend) Use get_personality()
Date: Sat, 23 Feb 2008 12:27:10 +0300
Message-ID: <20080223092710.GD2262@martell.zuzino.mipt.ru>

> On Sat, Feb 23, 2008 at 04:59:44PM +0800, WANG Cong wrote:
> > From: Alexey Dobriyan <adobriyan@gmail.com>
> > Subject: Re: [PATCH 00/16] (Resend) Use get_personality()
> 
> > > On Sat, Feb 23, 2008 at 04:14:03PM +0800, WANG Cong wrote:
> > > > This patchset makes the macro get_personality function alike
> > > > and teaches code to use get_personality() instead of explicit
> > > > reference.
> > > > 
> > > > [I am sorry if you've received multiple copied of this, since
> > > >  my git-send-email doesn't work well. ]
> > > 
> > > Yes, but why? "current->personality" is way more understandable than
> > > your macro because task subject to dereference is very visible.
> > 
> > Use get_personality() can hide the task_struct internals a bit.
> 
> ->personality is going to become something less trivial?
> Sorry, but you sound like C++ people writing tons of pointless get/set
> wrappers. And your get_personality() is worse -- C++ would write it as
> 
> 	current->personality()
> 
> and again, even here, it's immediately visible that current task is
> involved, not some other task.
> 

Can't get_personality() mean getting the personality of current task?

Or you want a more generic macro like this?

#define get_task_personality(tsk) ((tsk)->personality)

No, that is _too_ generic. Look at the code, (nearly) all references to
'personality' are via 'current'. So get_personality() is enough.

I am not a fan of C++, I know that sometimes the get/set method in C++
is really a bit pointless, but, of course, *not* all the times.

Regards.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752579AbYCHJEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbYCHJEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 04:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYCHJEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 04:04:13 -0500
Received: from po-out-1718.google.com ([72.14.252.157]:42364 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYCHJEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 04:04:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=PPaagu0AfMdgri2472/YICteIqR8OuMZ0vJe+mMk8H//XfuAJcU7z1MgACbXboHt+w+OIiyDyqpP/oBNMzG6K3u7GX8emgzE4jQB/QAEdtsz53ce4QygU24SnWAX3y2FD2nLYmfE2LMHi0MJ8mou75O+F8M9g3wI6yz8EvIcrYM=
Date: Sat, 08 Mar 2008 16:58:21 +0800 (CST)
Message-Id: <20080308.165821.119846418.xiyou.wangcong@gmail.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, gvaughan@jpl.nasa.gov, akpm@osdl.org,
       jeremy@goop.org
Subject: Re: [PATCH] Fix check after use in kernel/exit.c
From: WANG Cong <xiyou.wangcong@gmail.com>
In-Reply-To: <20080308085322.GA29628@elte.hu>
References: <20080308.161105.253167431.xiyou.wangcong@gmail.com>
	<20080308083637.GA23555@elte.hu>
	<20080308085322.GA29628@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 8 Mar 2008 09:53:22 +0100

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > @@ -582,9 +582,9 @@ static void exit_mm(struct task_struct * tsk)
> > >  {
> > >  	struct mm_struct *mm = tsk->mm;
> > >  
> > > -	mm_release(tsk, mm);
> > >  	if (!mm)
> > >  		return;
> > > +	mm_release(tsk, mm);
> > 
> > thanks, applied. I'm wondering why this never seems to hit in 
> > practice.
> 
> actually, i unapplied it again because the patch is wrong: mm_release() 
> has side-effects for kernel threads such as the deactivate_mm() [which 
> is important even if the user-mm is NULL]. If the NULL mm dereference 
> can really trigger then it should be avoided within mm_release().
> 

Do you mean that the NULL check should be moved into mm_release()?

Thanks!

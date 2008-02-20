Return-Path: <linux-kernel-owner+w=401wt.eu-S1764447AbYBTFy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764447AbYBTFy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753971AbYBTFyG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:54:06 -0500
Received: from qb-out-0506.google.com ([72.14.204.225]:48539 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396AbYBTFyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:54:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c7Df7+2BVme6KJtukZqtF/pk4pKaJWxyu27RegEJjU2r5Ts39y1UqHEvzysl98UPzR+IEPP0bhxHPXORnD9hC3JLBwQiysqW4VC8RlAPdzUOTzGMd+0l3rbtnM0aiwggjwjogimHDN3UurG5yR0OEg/4NCaj3P798E+XUQYr7+I=
Subject: Re: [PATCH 1/5] signal(x86_32): Improve the signal stack overflow
	check
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Shi Weihua <shiwh@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080220024928.0EE172701BA@magilla.localdomain>
References: <47B95C4D.6080000@cn.fujitsu.com>
	 <20080218134720.GA28851@elte.hu> <47BA299A.3040207@cn.fujitsu.com>
	 <20080219185009.122ED2701BA@magilla.localdomain>
	 <47BB7922.1010400@cn.fujitsu.com>
	 <20080220011822.C510B2701BA@magilla.localdomain>
	 <47BB83E2.1030504@cn.fujitsu.com>
	 <20080220014419.B85D02701BA@magilla.localdomain>
	 <47BB8F05.3050001@cn.fujitsu.com>
	 <20080220024928.0EE172701BA@magilla.localdomain>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 21:54:07 -0800
Message-Id: <1203486847.23194.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-19 at 18:49 -0800, Roland McGrath wrote:
> > I spent some time read you mail carefully and dig into the code again.
> > 
> > And yes, you are right. It's possible that SA_ONSTACK has been cleared
> > before the second signal on the same stack comes.
> 
> It's not necessary for SA_ONSTACK to have "been cleared", by which I assume
> you mean a sigaction call with SA_ONSTACK not set in sa_flags.  That is
> indeed possible, but it's not the only case your patch broke.  It can just
> be a different signal whose sigaction never had SA_ONSTACK, when you are
> still on the signal stack from an earlier signal that did have SA_ONSTACK.
> 
> > So this patch is wrong  :( . I will revise the other 4 patches.
> 
> For 2 and 3, I would rather just wait until we unify signal.c anyway.
> 

I've been looking at that, at the same time a bunch of ia32/signal.c
looks like it can go away.

Harvey


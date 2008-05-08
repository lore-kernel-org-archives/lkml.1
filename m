Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbYEHXrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbYEHXrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:47:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYEHXrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:47:23 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45014 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYEHXrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:47:22 -0400
Date: Fri, 09 May 2008 08:46:54 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] call_usermodehelper_setup() should use GFP_KERNEL
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <menage@google.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <4822F8E4.4040401@goop.org>
References: <20080508193224.0EFF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <4822F8E4.4040401@goop.org>
Message-Id: <20080509084248.43B5.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Yeah, but making the caller need to know about the internal 
> >> implementation details of the callee (ie, whether it needs to allocate 
> >> memory or not) leads to pretty warty interfaces.  In this case, you 
> >> could push the gfp_t up to the call_usermodehelper_setup() level, but 
> >> pushing it any higher wouldn't make much sense.
> >
> > No problem :)
> > almost caller doesn't call call_usermodehelper_setup() directly.
> >
> > thus, call_usermodehelper_setup() chage is hided in call_usermodehelper().
> 
> Yep, seems reasonable.  Are there any UMH_NO_WAIT callers who could be 
> using GFP_KERNEL?

UMH_WAIT_EXEC and UMH_WAIT_PROC mean wait on finish of exec or process exit.
I can't imagine situation that exec is waitable *and* allocate isn't waitable.




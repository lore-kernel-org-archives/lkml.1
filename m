Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbYE1Eww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbYE1Eww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 00:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYE1Ewn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 00:52:43 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65040 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbYE1Ewn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 00:52:43 -0400
Message-ID: <483CE4B8.4030304@cn.fujitsu.com>
Date: Wed, 28 May 2008 12:51:04 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Paul Menage <menage@google.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <andi@firstfloor.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] call_usermodehelper() increase reliability
References: <20080527212423.9CAD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080527212423.9CAD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Now, call_usermodehelper_setup() uses GFP_ATOMIC.
> but it can return NULL _very_ easily.
> 
> GFP_ATOMIC is needed only when we can't sleep.
> and, GFP_KERNEL is robust and better.
> 
> thus, I add gfp_mask argument to call_usermodehelper_setup().
> 
> So, its caller pass below,
> 
> call_usermodehelper() and call_usermodehelper_keys(): 
> 	depend on 'wait' argument.
> call_usermodehelper_pipe():
> 	always GFP_KERNEL because always run under process context.
> orderly_poweroff():
> 	pass to GFP_ATOMIC because may run under interrupt context.
> 

I have no problem with this patch.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

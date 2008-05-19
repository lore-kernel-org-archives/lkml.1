Return-Path: <linux-kernel-owner+w=401wt.eu-S1760818AbYESNpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760818AbYESNpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbYESNpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:45:06 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:15063
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350AbYESNpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:45:05 -0400
Message-ID: <4831845F.6030904@qumranet.com>
Date: Mon, 19 May 2008 16:45:03 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] Make LIST_POISON less deadly
References: <1211125094-32167-1-git-send-email-avi@qumranet.com> <20080519130151.GE13546@elte.hu>
In-Reply-To: <20080519130151.GE13546@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i'd suggest to add an ARCH_ILLEGAL_POINTER define instead, which 
> defaults to zero and gets added to pointer-ish poison values. That makes 
> it both simpler and also it does not need any include/asm changes 
> because ARCH_ILLEGAL_POINTER can be set from the Kconfig space.
>   

Any idea how to override a value in Kconfig?  We can do it for bool 
values but not strings.

e.g.

lib/Kconfig:
  config ILLEGAL_POINTER_VALUE
      hex
      default 0

arch/x86/Kconfig:
  config X86
    select ILLEGAL_POINTER_VALUE=0x80000000000000000000000000 if X86_64

?

I could do it with a boolean signifying existence and a hex for the 
value, but I'd rather not.

-- 
error compiling committee.c: too many arguments to function


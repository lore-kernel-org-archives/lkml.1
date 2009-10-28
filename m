Return-Path: <linux-kernel-owner+w=401wt.eu-S1757384AbZJ1F1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbZJ1F1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 01:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757328AbZJ1F1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 01:27:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44121
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757322AbZJ1F1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 01:27:51 -0400
Date: Tue, 27 Oct 2009 22:28:14 -0700 (PDT)
Message-Id: <20091027.222814.137568780.davem@davemloft.net>
To: airlied@linux.ie
Cc: dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: is avoiding compat ioctls possible?
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.00.0910280353080.19088@skynet.skynet.ie>
References: <alpine.DEB.2.00.0910280341331.19088@skynet.skynet.ie>
	<20091027.204530.142024242.davem@davemloft.net>
	<alpine.DEB.2.00.0910280353080.19088@skynet.skynet.ie>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@linux.ie>
Date: Wed, 28 Oct 2009 03:54:34 +0000 (GMT)

>> 
>> > we already opencoded this (probably before it was macroisied or we just 
>> > pasted it), so the radeon one is buggy, I should just go and compat_* all 
>> > of these then and we should be all happy?
>> 
>> It should be, it's only working because:
>> 
>> 1) A malicious userland hasn't put garbage in the upper bits for
>>    you yet.
>> 
>> 2) Nobody has tested s390 yet :-)
>> 
> 
> So will an inline like this work?
> 
> static inline void *__user convert_user_ptr(uint64_t ioctl_ptr)
> {

Please don't do this.

This is exactly what I feared people would do when is_compat_task()
was added.  is_compat_task() is for situations where there is
otherwise no other way to handle the compat situation properly.

It's not that much work for you to hook up the compat ioctls properly,
and if you are clever you can do it in such a way that you'll get
warnings if someone accidently adds a new ioctl but forgets the
compat bits :-)

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbZJ3BNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbZJ3BNG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 21:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbZJ3BNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 21:13:05 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:42005 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbZJ3BNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 21:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Td+NeKznqCYiDfybvb64/07yWvhFMjVxPD0WCI3SWOjdFtMKoUVJm4bXtte3TY53KT
         QF8qIqJPHFfVHQvTboZe2kDRiWY9ZQeKpJkYh0vdVud5yWxGVQHsnG3oei+LlNLhcllE
         RBermirxiTkgGD731B4hDh9cyWhHvdGUqLYI0=
MIME-Version: 1.0
In-Reply-To: <20091028.005342.60092591.davem@davemloft.net>
References: <20091027.222814.137568780.davem@davemloft.net>
	 <alpine.DEB.2.00.0910280539150.19088@skynet.skynet.ie>
	 <20091027.230450.222178419.davem@davemloft.net>
	 <20091028.005342.60092591.davem@davemloft.net>
Date: Fri, 30 Oct 2009 11:13:08 +1000
Message-ID: <21d7e9970910291813u19cdd361u2facb864db58a712@mail.gmail.com>
Subject: Re: is avoiding compat ioctls possible?
From: Dave Airlie <airlied@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: airlied@linux.ie, dri-devel@lists.sourceforge.net, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 28, 2009 at 5:53 PM, David Miller <davem@davemloft.net> wrote:
> From: David Miller <davem@davemloft.net>
> Date: Tue, 27 Oct 2009 23:04:50 -0700 (PDT)
>
>> From: Dave Airlie <airlied@linux.ie>
>> Date: Wed, 28 Oct 2009 05:42:27 +0000 (GMT)
>>
>>> I'll add this to my TODO for before the next merge window as its
>>> definitely more than I can manage now.
>>
>> I'll do it.

Btw when I mentioned ioctls I meant more than radeon, all the KMS
ioctls in the common drm_crtc.c file suffer from this problem as well.

Hence why I still believe either my drm specific inline or something
more generic (granted I can see why a generic solution would be ugly).

You patch below does suffer from a lot of #ifdefs and cut-n-paste
that is a lot better suited to doing in an inline or macro. We can then
comment that inline saying if anyone else does this we will be most
unhappy.

Dave.

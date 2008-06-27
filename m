Return-Path: <linux-kernel-owner+w=401wt.eu-S1760154AbYF0Isq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760154AbYF0Isq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 04:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbYF0Isj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 04:48:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58448 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753899AbYF0Isi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 04:48:38 -0400
Message-ID: <4864A960.7010807@firstfloor.org>
Date: Fri, 27 Jun 2008 10:48:32 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH, RFC] fasync() BKL pushdown (take 2)
References: <20080620112914.783be428@bike.lwn.net>	<485BEEF7.2020404@firstfloor.org>	<20080620130905.6694a7be@bike.lwn.net>	<485C0133.3020708@firstfloor.org> <20080625163052.344a2957@bike.lwn.net>
In-Reply-To: <20080625163052.344a2957@bike.lwn.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> On Fri, 20 Jun 2008 21:12:51 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
>> Some devices do state change even when the reference count is > 0.
>> Would need to double check it's all ok with the fasync list.
> 
> OK, I've gone over all of the fasync() definitions again with an eye
> toward convincing myself that the fasync list would not get cleared,
> freed, or otherwise molested if fasync() runs without BKL protection.
> I focused especially on other code (open(), ioctl()) which might still
> run with the BKL.  The result was two more pushdowns in spots where I
> wasn't sure; chance are both are unnecessary.

Ok fine for me then. I haven't read it again in detail, but it sounds
good now.

I still think it would be better to somehow compile break external users,
but that would be only the icing on the cake.

Acked-by: Andi Kleen <ak@linux.intel.com>

-Andi


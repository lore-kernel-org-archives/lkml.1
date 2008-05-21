Return-Path: <linux-kernel-owner+w=401wt.eu-S935465AbYEUQW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935465AbYEUQW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 12:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765015AbYEUQWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 12:22:50 -0400
Received: from gv-out-0910.google.com ([216.239.58.186]:57317 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764120AbYEUQWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 12:22:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=J5lyy8rJi7ACBa3rDWCcuBRNjICC2UVPwp4jHFp5aPtw2MTiBsaoXpsIC+dPieUR2Gbpnbpv1xkcXjcj3QvfxljXl2rpyxnizzUYXxZ+jqzeXOTH17CFnRInvKKVe3Ag5h732ygXfU8s82EAVyC3zApisjxmfQ6RcupddRJ1aZo=
Message-ID: <8bd0f97a0805210922n2dc871b6y67377944cc60b566@mail.gmail.com>
Date: Wed, 21 May 2008 12:22:46 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: [PATCH 1/3, RFC] misc char dev BKL pushdown
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Wu, Bryan" <Bryan.Wu@analog.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Alexander Viro" <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
In-Reply-To: <9968.1211325938@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0805201601h1b08df6fw3fbf6c58759b07b4@mail.gmail.com>
	 <9968.1211325938@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 7:25 PM, Jonathan Corbet wrote:
> Mike Frysinger wrote:
>> please drop the coreb.c changes from your patch
>
> At a minimum, I would hope such a request would say something like "I've
> looked at the driver's locking and am convinced that the BKL is not
> needed."  Have you done that?  There is a certain leap of faith involved
> in removing that protection from a driver.
>
> I decided to take a quick look...
>
> - You use spin_lock_irq(&coreb_lock) in a number of places, but you do
>  not take the lock in the interrupt handler.  You also do not take the
>  lock in coreb_write() or coreb_read(), so those can race with the
>  interrupt handler, with ioctl(), and with each other.

the lock is to protect one thing: coreb_status.  we lock around any
access to it, so it not being grabbed in the irq handler or any other
function where coreb_status is not utilized is irrelevant.  that means
the BKL is not needed in the driver.

the rest of your comments are more or less on target, but again
irrelevant to the topic of the BKL.  i'll keep them in mind when i
rewrite the driver, thanks.
-mike

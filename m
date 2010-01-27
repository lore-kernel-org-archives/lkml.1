Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413Ab0A0OxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0A0OxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:53:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225Ab0A0OxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:53:15 -0500
Received: from mail.perches.com ([173.55.12.10]:1510 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754954Ab0A0OxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:53:15 -0500
Subject: Re: +
 drivers-block-floppyc-remove-copyin-copyout-and-ecall-macros.patch added to
 -mm tree
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, bzolnier@gmail.com, jens.axboe@oracle.com,
       marcin.slusarz@gmail.com, shemminger@vyatta.com
In-Reply-To: <4B600AB7.3070705@gmail.com>
References: <201001270037.o0R0bqQC032566@imap1.linux-foundation.org>
	 <4B600AB7.3070705@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 06:53:13 -0800
Message-ID: <1264603993.14552.71.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 10:43 +0100, Jiri Slaby wrote:
> On 01/27/2010 01:37 AM, akpm@linux-foundation.org wrote:
> > @@ -3145,7 +3136,9 @@ static inline int raw_cmd_copyout(int cm
> > -		COPYOUT(*ptr);
> > +		ret = copy_to_user((void __user *)param, ptr, sizeof(*ptr));
> > +		if (ret)
> > +			return -EFAULT;
[]
> > -		COPYIN(*ptr);
> > +		ret = copy_from_user(ptr, (void __user *)param, sizeof(*ptr));
> 
> Actually the casts are not needed anymore, are they?

There's still some char/void silliness.
It certainly could be improved/removed.

Do feel free to submit patches with your
desired level of changelog prolixity.

cheers, Joe


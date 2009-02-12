Return-Path: <linux-kernel-owner+w=401wt.eu-S1759783AbZBLVMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783AbZBLVMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZBLVM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:12:29 -0500
Received: from mail-bw0-f161.google.com ([209.85.218.161]:36362 "EHLO
	mail-bw0-f161.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbZBLVM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:12:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZbKFLk55A9lvApr+8LQGxnTBYuJI5viwsKlf+duDxDirhiF5/MbRHw10G1zmCM5QQT
         cgbNfZdEWQJbg53SultJBAjJ1z5w0K058K1XkLD4DZ5TIi8uUBziOfdKX0sgst75Q8Ia
         rt2r5CGnZ6jXtEpCgy2NRzANPgCZRcEX6glio=
MIME-Version: 1.0
In-Reply-To: <20090211142409.b88c577e.akpm@linux-foundation.org>
References: <46e1c7760901230433i3045f273oa109ce97e790bca3@mail.gmail.com>
	 <Pine.LNX.4.64.0901240951110.13803@anakin>
	 <46e1c7760901240109m5a0f3a85p788aa3ce35b49fa9@mail.gmail.com>
	 <Pine.LNX.4.64.0901241425310.13803@anakin>
	 <46e1c7760901240649v1e45bbb1v8c9997f236a3ec4c@mail.gmail.com>
	 <46e1c7760902101337qe239336n9ef2652a47f89aed@mail.gmail.com>
	 <46e1c7760902101350r5a04d076j49cc611a843e6429@mail.gmail.com>
	 <20090211142409.b88c577e.akpm@linux-foundation.org>
Date: Thu, 12 Feb 2009 23:12:26 +0200
Message-ID: <46e1c7760902121312o1476e734xc1fc1d6e11ce4d2e@mail.gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH] fb: hide cursor in graphics mode
From: Risto Suominen <risto.suominen@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: geert@linux-m68k.org, adaplas@pol.net,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/12 Andrew Morton <akpm@linux-foundation.org>:
>> ---
>> The testing is done on kernel version 2.6.18.
>
> That's a truly ancient kernel.  Is the patch needed on current kernels?
> Does it work correctly in current kernels?
>
It does not on 2.6.24. The patch works.

> How does the cursor get re-enabled?
>
I have not thought of that.

> Should we be calling ops->cursor() if fbcon_is_inactive() is true?
>
Maybe we shouldn't, but we must. The situation is that we are ordered
to enter graphics mode and the variable saying 'graphics' is already
set in vt_ioctl.c. fbcon_is_inactive() tests it and returns true.

The question is, whether this function is called later during normal
operation, and how often?

Risto

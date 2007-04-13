Return-Path: <linux-kernel-owner+w=401wt.eu-S1753643AbXDMNal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643AbXDMNal (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbXDMNal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:30:41 -0400
Received: from wr-out-0506.google.com ([64.233.184.235]:65286 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbXDMNak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:30:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GW8+G66Jhi3K43MYd9sqBWngXMvjsTMOFctbBQtLBMlSlF8azE4geKxWPwFmWWE5zDDdzyouV4f04lnpBS5acK1+kSNeFv8GsPTuaWEBptgL/eLJU3z9a6I6+lcjLTGcxcsaY8moJIzNn5+QLdsPghGeGyTv3/ju7xdhECU8aik=
Message-ID: <38b2ab8a0704130630v4c840bd1w19f2a239f86a93b@mail.gmail.com>
Date: Fri, 13 Apr 2007 15:30:38 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Subject: Re: [CRYPTO] is it really optimized ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <461F74F0.1070206@aitel.hist.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38b2ab8a0704121239sd848440t6ed23d71dc68798c@mail.gmail.com>
	 <461F74F0.1070206@aitel.hist.no>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 4/13/07, Helge Hafting <helge.hafting@aitel.hist.no> wrote:
> Francis Moreau wrote:
> > So is this interpretation right ? If so wouldn't it be appropriate to
> > introduce a mechanism to reserve this AES hardware for a special
> > purpose (filesystem encryptions) and thus make it as fast as possible
> > ?
> >
> Would this really help?
> When reading/writing files, most of the time is i/o-wait, isn't it?
>

Well some systems, specially embedded ones, don't use hard drives for
mass storage purposes but rather MTD like flashes...

> Reserving the device exclusively seems excessive. How about
> a quick test to see if someone else have been using it since
> the last time your crypto-fs used it?  If nobody else used it, then
> you don't need to reset they key and so on.
>

You would spend the same time to make the test as loading the key...

> If nobody else is using the AES controller, you get the same speed
> as with a reservation.

I don't think this is right. AES hardware can do a block encryption in
a very few cycles. If you copy the key or test the key to see if it
has changed as you proposed, then you basically increase the execution
time by a factor 2 or 3...

> If something else is using AES then it won't be
> as fast, but then the AES controller have been used for other useful
> work as well.  Other parts of the kernel surely won't use it just for
> fun. :-)

You said it: others parts of the kernel are unlikely to use it. So why
not optimizing the common case ?

Crypto core already seems to implement a priority mechanism. But I
don't think I'm able to say "I'd like to use this algo for encrypting
filesystems. If another part of the kernel wants to use this algo then
give it the generic one". This choice seems really to depend on the
system the kernel is running.
-- 
Francis

Return-Path: <linux-kernel-owner+w=401wt.eu-S1764429AbYETAqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764429AbYETAqX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 20:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbYETAqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 20:46:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:39323 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960AbYETAqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 20:46:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G1jifw6uKGubHwVzMxaj78nMvicpuQY8vGn8N3iWAwsAVdOn6+oelV+ezbS0zz2p2zKg8RSpYdMpF10aIEUJFvYljXhYQrSBn/7onNyLlRZjOxC8Oibb8R5VT6zwEGHSAkLQta4ylaPWrKOzqTFPfDCTR1XIxqsi1kWPUQY8LZw=
Message-ID: <8bd0f97a0805191746n12f4ef4by9dbb675b4d289ae1@mail.gmail.com>
Date: Mon, 19 May 2008 20:46:11 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jonathan Corbet" <corbet@lwn.net>
Subject: Re: [PATCH 1/3, RFC] misc char dev BKL pushdown
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Alexander Viro" <viro@ftp.linux.org.uk>,
       "Arnd Bergmann" <arnd@arndb.de>, linux-kernel@vger.kernel.org
In-Reply-To: <30821.1211242876@vena.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0805191707k597e4f48i9c54488777fdd91b@mail.gmail.com>
	 <30821.1211242876@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 8:21 PM, Jonathan Corbet wrote:
> Mike Frysinger wrote:
>> this open func already has a spinlock protecting it.  doesnt that mean
>> we dont need the bkl in it ?
>
> The existence of a spinlock is a good sign.  But, until somebody has
> looked at the code and verified that said lock is really protecting
> everything, it's best to leave the BKL protection (which has always been
> there, just at a higher level) in place.

if the spinlock doesnt do what it's advertising (preventing mutual
access), then the BKL is needed.  if there's some UP behavior i'm not
aware of, then the BKL is needed.  otherwise, the BKL is not needed in
this driver.

i should prob rewrite this driver anyways ... the open code could
easily be replaced with some atomic funcs.
-mike

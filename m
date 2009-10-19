Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbZJSE1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbZJSE1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 00:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZJSE1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 00:27:15 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:45422 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZJSE1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 00:27:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=X5Prju3xBh6R0/p4saP+I3zz6z//oHN5WYm6G5dAkZId5zAAR7H3wuH2HbMvfxkyQg
         6mIe6JoZ2C8okwY0A4Kkos+9YcEeaJnS672S4aDy7UVKn4wvU5SYmlh5oGeL/FRZUMUZ
         tltu8GSpYeM6hzgtpCT48jvBLnX8dbVhQyTWg=
From: Arnd Bergmann <arndbergmann@googlemail.com>
To: John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH RFC] raw: Remove the BKL from raw_open
Date: Mon, 19 Oct 2009 06:27:13 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-11-generic; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arnd Bergmann <arndbergmann@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Jonathan Corbet <corbet@lwn.net>
References: <alpine.LFD.2.00.0910182252330.3462@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0910182252330.3462@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910190627.13368.arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 18 October 2009, John Kacur wrote:
> The BKL was pushed into raw_open with
> commit c0bed680f0ca603864375ed5f9fed4296a53aa62
> 
> Jonathan's comments were " Put explicit lock_kernel() calls into raw_open(),
> even though the existing locking looks adequate."
> 
> I have to agree, the raw_mutex should provide all the protection needed here.

The raw driver uses the BKL in both the ioctl and the llseek function, so
I think you have to look if there is any interaction between those and the
open method, ideally removing it from all of them at the same time.

An unrelated bug I spotted while looking at your patch is that there is no
compat_ioctl method in the raw file_operations, which is really needed here
if you want any of the block ioctls to work on a compat task.

Whatever that tells us...

	Arnd <><

Return-Path: <linux-kernel-owner+w=401wt.eu-S933536AbXCTOlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933536AbXCTOlE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 10:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933537AbXCTOlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 10:41:04 -0400
Received: from mailout18.yourhostingaccount.com ([65.254.253.144]:39527 "EHLO
	mailout18.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933536AbXCTOlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 10:41:01 -0400
X-Greylist: delayed 1782 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 10:41:00 EDT
Message-ID: <000601c76af9$a0ce3ce0$0864a8c0@scs1>
From: "Tasos Parisinos" <t.parisinos@sciensis.com>
To: "Francois Romieu" <romieu@fr.zoreil.com>
Cc: <herbert@gondor.apana.org.au>, <linux-kernel@vger.kernel.org>
References: <45FEB8B7.7020200@sciensis.com> <20070320004001.GA11601@electric-eye.fr.zoreil.com>
Subject: Re: [PATCH RESEND 1/1] crypto API: RSA algorithm patch (kernel version 2.6.20.1)
Date: Tue, 20 Mar 2007 16:11:11 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-EN-UserInfo: 6b5ac0c6b5a8f649d336ffa6ba3f3bc4:297516c839f78035fb456ced5af6b435
X-EN-AuthUser: tparisinos@sciensis.com
X-EN-OrigIP: 88.218.52.108
X-EN-OrigHost: dsl-88-218-52-108.customers.vivodi.gr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francois Romieu wrote:

> RSA is slow. syscalls are fast.
> 
> Which part of the kernel is supposed to benefit from this code ?

The main purpose behind the development of this module was to create an in-kernel 
system of signed modules. The scenario applies most in embedded systems that are running linux
where the kernel is physically secure but its filesystem is not, so one may tamper executable code.

In such systems we need to detect the tampering in a centralized way (e.g without using hash databases e.t.c). 
So what you need to do is sign the executable (or the library) with a private key and have a kernel that will 
use the public key part to authenticate the executable againts its digital signature.

Of course the signing and the authentication is not done against the whole executable but against its 
secure hash, and this takes milliseconds to complete before loading the code onto memory.
You see, in such a usage scenario most of the time the kernel will spend will be on hashing (sha1 module) and not in 
modular exponentiation. Of course this will not produce any soft lockups

Such a system cannot depend on userland to do the authentication for obvious security reasons, it 
must be in kernel.

Of course sha1 is slow as well but there is an sha1 module for anyone who may need it.
That was my idea, we developed it for our own security needs, why not make it available for
others that may want to use it?

Furthermore one can use the API to do multi-precision arithmetics, if any kernel module may need it

--
Tasos Parisinos


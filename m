Return-Path: <linux-kernel-owner+w=401wt.eu-S933964AbXHXBFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933964AbXHXBFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 21:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762389AbXHXBE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 21:04:58 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:4768 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764058AbXHXBE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 21:04:57 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: division and cpu usage
Date: Thu, 23 Aug 2007 18:04:49 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEBMGGAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-2"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <46CE1BA2.8070200@gmail.com>
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Thu, 23 Aug 2007 18:05:20 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Thu, 23 Aug 2007 18:05:21 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Hello.
>
> I'm new to kernel development and have some questions.
>
> 1. Why can't I divide with regular casting to double ((double)a /
> (double)b)? It gives me strange errors when compiling:
>
> WARNING: "__divdf3" [/root....] undefined!
> WARNING: "__addf3" [/root/...] undefined!
> WARNING: "__floatsidf" [/root/...] undefined!
>
> And if I compile with normal integers, I get zero as the result.

As the HOWTO says:

"The kernel is written using GNU C and the GNU toolchain.  While it
adheres to the ISO C89 standard, it uses a number of extensions that are
not featured in the standard.  The kernel is a freestanding C
environment, with no reliance on the standard C library, so some
portions of the C standard are not supported.  Arbitrary long long
divisions and floating point are not allowed.  It can sometimes be
difficult to understand the assumptions the kernel has on the toolchain
and the extensions that it uses, and unfortunately there is no
definitive reference for them.  Please check the gcc info pages (`info
gcc`) for some information on them."

The short version is simply that it's very expensive to allow this, adding
overhead even in cases where it isn't used, and there is very little
benefit. For almost every imaginable case where you would want floating
point in the kernel, fixed point works as well or better.

Just scale your numbers by shifting them.

DS



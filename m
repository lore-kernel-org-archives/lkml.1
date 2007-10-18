Return-Path: <linux-kernel-owner+w=401wt.eu-S934969AbXJRWxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934969AbXJRWxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761732AbXJRWxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:53:18 -0400
Received: from queueout03-winn.ispmail.ntl.com ([81.103.221.33]:47645 "EHLO
	queueout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761690AbXJRWxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:53:16 -0400
X-Greylist: delayed 1177 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2007 18:53:16 EDT
Date: Thu, 18 Oct 2007 23:33:33 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [bisected][mismerge?] Re: [microcode] 2.6.23.git pulled this morning oopses loading P4 microcode
Message-ID: <20071018223333.GD4153@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>
References: <1192681533.7147.5.camel@Homer.simpson.net> <1192730198.7182.18.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1192730198.7182.18.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

Mike Galbraith, le Thu 18 Oct 2007 19:56:38 +0200, a écrit :
> The winner of a very long git bisect session:
> 
>     unicode diacritics support

Uh, I fail to see how that could have an impact, I've again checked the
boundaries, it looks fine, please people have a look.

Could you try something odd?  On your tree that has the change reverted,
please try the attached patch, which makes the array the same size at it
would be with the change, possibly triggering bugs in completely other
parts of the kernel.

Samuel

--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch

--- defkeymap.c_shipped.old	2007-10-18 22:44:59.000000000 +0000
+++ defkeymap.c_shipped	2007-10-18 22:44:43.000000000 +0000
@@ -222,7 +222,7 @@
 	NULL,
 };
 
-struct kbdiacr accent_table[MAX_DIACR] = {
+struct kbdiacr accent_table[(MAX_DIACR*3*4-MAX_DIACR*3)/3] = {
 	{'`', 'A', '\300'},	{'`', 'a', '\340'},
 	{'\'', 'A', '\301'},	{'\'', 'a', '\341'},
 	{'^', 'A', '\302'},	{'^', 'a', '\342'},

--cNdxnHkX5QqsyA0e--

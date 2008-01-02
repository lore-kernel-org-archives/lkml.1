Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbYABLpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbYABLpu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 06:45:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753625AbYABLpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 06:45:42 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:35687 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbYABLpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 06:45:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=FqKaxM0svjtkS+Es+nQyUElNdLbPCtTP4amUNl1UKHQu+/d4PLQCeqTp1uZRq53uYNy3JKy5Hz8SFqAAuTgAdw+cau8yGTKM2trFqH+SMVJfVw5tuq2V4GzxDx1WqsmO35qGNKnvG43oZfkGp4lH5uIEgAevbBrHHOdUHiIQIwk=
Message-ID: <60d29d630801020345i200a2f72pe860b0d38b530a05@mail.gmail.com>
Date: Wed, 2 Jan 2008 12:45:39 +0100
From: Abdel <draconux@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: macro _set_base - "do - while(0)" question
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In file include/asm-i386/system.h,  _set_base and _set_limit use an
useless do ... while(0)

Why is this needed ?

exemple with _set_base from linux-2.6.23

#define _set_base(addr,base) do { unsigned long __pr; \
__asm__ __volatile__ ("movw %%dx,%1\n\t" \
	"rorl $16,%%edx\n\t" \
	"movb %%dl,%2\n\t" \
	"movb %%dh,%3" \
	:"=&d" (__pr) \
	:"m" (*((addr)+2)), \
	 "m" (*((addr)+4)), \
	 "m" (*((addr)+7)), \
         "0" (base) \
        ); } while(0)


-- 
Abdel
http://draconux.free.fr/

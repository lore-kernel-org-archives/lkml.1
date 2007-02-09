Return-Path: <linux-kernel-owner+w=401wt.eu-S1946604AbXBIQHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946604AbXBIQHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946593AbXBIQHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:07:47 -0500
Received: from qb-out-0506.google.com ([72.14.204.235]:22744 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946601AbXBIQHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:07:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ow18LlPl2v7EfhJJ9ChZtOxKo/t/KWBl8VPgFneAMzJWSpJgfqN9p9h+4rGsCB77DByFlz31lDZnKpLYDqjcdgPx6+BD+Bppg64MFlC7BFIj3cCPnW7jfj59cUfqxk08Yl5trPx44m4b7+/32kqnna7ttcLj6qS+UPPwbMT0PIg=
Message-ID: <38b2ab8a0702090807m133e8f89n9857b8f7814e3685@mail.gmail.com>
Date: Fri, 9 Feb 2007 17:07:41 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question about EXPORT_SYMBOL implementation
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the implementation of EXPORT_SYMBOL:

#define __EXPORT_SYMBOL(sym, sec)                               \
        extern typeof(sym) sym;                                 \
        __CRC_SYMBOL(sym, sec)                                  \
        static const char __kstrtab_##sym[]                     \
        __attribute__((section("__ksymtab_strings")))           \
        = MODULE_SYMBOL_PREFIX #sym;                            \
        static const struct kernel_symbol __ksymtab_##sym       \
        __attribute_used__                                      \
        __attribute__((section("__ksymtab" sec), unused))       \
        = { (unsigned long)&sym, __kstrtab_##sym }


I'm wondering why it's using '__attribute_used__' _and_
'__attribute__((section("__ksymtab" sec), unused)'. Isn't the unused
attribute redundant with '__attribute_used__' ?

thanks
-- 
Francis

Return-Path: <linux-kernel-owner+w=401wt.eu-S965420AbXBLVUq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965420AbXBLVUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 16:20:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965421AbXBLVUq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 16:20:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:34483 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965420AbXBLVUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 16:20:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PFFXQD9rw96xTJtTuonIDOBpXeqcWvhNeqlpqgsDqtOnLhL5enOZHc4Q1WOwRUcvTRM9BQOkWJK9BLB1+KM7Qsvy7xmYCkHWj5yx3q26ViAFW8uzIhKksPAeFpBJLClHCCr6HlK48P1gu946Vc6PPU4Iz4XDWYH2xIasS5ZYc/c=
Message-ID: <38b2ab8a0702121320w554f3d17q1316ed88c58bc638@mail.gmail.com>
Date: Mon, 12 Feb 2007 22:20:42 +0100
From: "Francis Moreau" <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Question about EXPORT_SYMBOL implementation [try #2]
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

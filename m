Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZCGXh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZCGXh2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 18:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750827AbZCGXhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 18:37:19 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:38987 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbZCGXhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 18:37:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=qn0xdTdAXLaXKJh2579/z1EZY3lf0cQmv93VOgeLHPkIMh8fciErmVzX2oPpVa8q5q
         ZTIrgfJGFgB1dQimVt4mKTiCnt1FU5DH36qwRZpEPlyYm4AzXDmF3WeCqZBSLB4dXbOD
         zL1Ip4zX7ZJAPDVaNcF3gIlF0qA4ZtWn9bIhA=
MIME-Version: 1.0
Date: Sat, 7 Mar 2009 23:37:15 +0000
Message-ID: <8b67d60903071537p10994257obc7cce99028a740c@mail.gmail.com>
Subject: printk issue - bug?
From: Adrian McMenamin <lkmladrian@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wonder if anyone can reproduce this behaviour on other architectures
(this was SH4)?

code is:

printk("PAGE_SIZE is 0x%X\n", PAGE_SIZE);
printk("Offset is 0x%X, PAGE_SIZE is 0x%X, readlen is 0x%X\n", offset,
PAGE_SIZE, readlen)

Output is:

[  162.603348] PAGE_SIZE is 0x1000
[  162.607473] Offset is 0x0, PAGE_SIZE is 0x0, readlen is 0x1000


ie PAGE_SIZE is incorrectly reported in the second printk (these are
consecutive lines of code)

offset is loff_t and readlen is unsigned long.

Adrian

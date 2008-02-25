Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbYBYGHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbYBYGHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYBYGGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:06:52 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:49014 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbYBYGGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:06:51 -0500
Message-ID: <47C25AE9.7080305@ak.jp.nec.com>
Date: Mon, 25 Feb 2008 15:06:33 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] exporting capability name/code pairs (final#2)
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following three patches enables to export code/name pairs of
capabilities the running kernel supports, and add a documentation
and samples to use this feature.

[PATCH 1/3] add a private data field within kobj_attribute structure.

This patch add a private data field, declared as void *, within kobj_attribute
structure. The _show() and _store() method in the sysfs attribute entries can
refer this information to identify what entry is accessed.
It makes easier to share a single method implementation with several similar
entries, like ones to export the list of capabilities the running kernel
supports.

[PATCH 2/3] exporting capability name/code pairs

This patch enables to export code/name pairs of capabilities the running
kernel supported.

A newer kernel sometimes adds new capabilities, like CAP_MAC_ADMIN
at 2.6.25. However, we have no interface to disclose what capabilities
are supported on the running kernel. Thus, we have to maintain libcap
version in appropriate one synchronously.

This patch enables libcap to collect the list of capabilities at run time,
and provide them for users. It helps to improve portability of library.

It exports these information as regular files under /sys/kernel/capability.
The numeric node exports its name, the symbolic node exports its code.

[PATCH 3/3] a new example to use kobject/kobj_attribute

This patch can provide a new exmple to use kobject and attribute.
The _show() and _store() method can refer/store the private data field of
kobj_attribute structure to know what entries are accessed by users.
It will make easier to share a single _show()/_store() method with several
entries.

o changes from the previous version
 - add a short description at Documentation/kobject.txt, to use private
   member within kobj_attribute.
 - "supported" is replaced with "supports" at sysfs-kernel-capability.
 - "$(src)/../" is replaced with "$(srctree)/" at security/Makefile
 - The private member is casted to long, when it stores integer value.

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>

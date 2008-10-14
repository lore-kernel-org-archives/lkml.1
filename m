Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbYJNV4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbYJNV4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 17:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYJNV4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 17:56:42 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:20361 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbYJNV4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 17:56:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=j3zKG0Aq0yKgtzdL1ft4o4T/7dVtQ6RLClHGqg4cPgfmkgngTtHoU0BaaUPi2Pw8Ph
         n+q2R2ez1Zbfo0HiiqcwNipEaGYPUY+sHP7TGwBCkvJRgaafVkgstvQLuCZaPkQyTfqh
         2+BZGCSYAVM3RxbV9bBCjHU2cIBTw5C3T9Cw8=
Message-ID: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com>
Date: Tue, 14 Oct 2008 14:56:40 -0700
From: "Kaz Kylheku" <kkylheku@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: GPL question: using large contiguous memory in proprietary driver.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have the following question. Suppose that some proprietary driver
(otherwise completely clean, based only on non-GPL symbols)
requires a large buffer of physically contiguous memory.

A GPL-ed driver could get this memory by having some boot-time
code compiled into the kernel which calls bootmem_alloc during
kernel initialization. This function would stash the address of the
memory into some global variable which is exported for the
module to use.

How do you solve this problem in a proprietary driver? It seems
like the above solution taints the kernel, because the kernel
provides a symbol which exists only for the sake of supporting
a proprietary driver.

Would it be okay to have a mechanism like this:
Suppose that  on the kernel command line, you could
request a boot-time memory allocation and give it a name.
For instance, the parameter:

   boot_alloc=foo,8192K

would create an 8192 kilobyte allocation, and associate it
with the string "foo".   A non-GPL function would be provided to
find the address of this memory, using the string "foo"
as the key. The proprietary driver would document the
requirement that it needs a memory region of at least
8192K, under the name "foo".

Help! :)

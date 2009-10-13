Return-Path: <linux-kernel-owner+w=401wt.eu-S1759009AbZJMHhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009AbZJMHhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZJMHhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:37:37 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:42514 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbZJMHhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:37:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=l1QZbdK6PPEnoQ/uFz8QSLq8avQyrkTEm9XjRciAuPyDtI59RniJtgwTq/LcdxnDiQ
         VxDvNfnKaCJcGwQgbMUkXJ+eilgFqbu8u7VGyU6Em4cRzGBiAa21u0kagxWKxwwq8C4o
         3B7ZBDpC15t1hLNnEMLSp4p+EkaiL6Wv3hdxg=
MIME-Version: 1.0
Date: Tue, 13 Oct 2009 13:07:00 +0530
Message-ID: <f22d86810910130037x48cac5c1s8928a6ff49dda381@mail.gmail.com>
Subject: Using intptr_t and uintptr_t in Kernel
From: "Leonidas ." <leonidas137@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello List,

I know variants of this questions have been asked on this list before,
but I could not
find a thread where a conclusion was reached, most of the time
responses were { I don't care,
developer's choice, might be in future } and variations thereof. But
one thing was clear
that do not mix userspace and kernel space data types.

Currently, I am porting a user space application to kernel, this app
uses intptr_t data type.

A look at linux/types.h shows that,

typedef unsigned long           uintptr_t;

but intptr_t is not defined at all. Also, isn't above definition
incorrect? Since the whole idea
behind uintptr_t is to store pointer in a int sized variable, are we
not assuming here that

sizeof(int) = sizeof(unsigned long ) on all archs? I have not worked
on all archs on which Linux
runs, but if that is the case then above definition is correct.

After looking at stdint.h (which is not available for kernel),

typedef __s32 intptr_t;
typedef __u32 uintptr_t;

sounds more appropriate. Please CMIIW.

-Leo.

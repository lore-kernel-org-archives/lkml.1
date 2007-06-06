Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbXFFRDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbXFFRDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbXFFRDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:03:16 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:15945 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbXFFRDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:03:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=kW5JjotEPcSz6pCUqI4lqC9vauEknJNwnkTeidxq+s18+0Ibf2wKjucpyrUF0JKZFWurn8cOWoXUhNpx759YiCQviY8p9seJF6bcO/iQb5wqXGq8D5ZKgfRaUkI8fDSNCI+ar3+rPhWLD2zT/NYzN1HE40Faa1Ctc/0RzygkW4I=
Message-ID: <5d96567b0706061003r462c324i733ad3698ac3d90c@mail.gmail.com>
Date: Wed, 6 Jun 2007 20:03:14 +0300
From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: kmap_atomic in 2.6.20.x
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

I am running into some problems with kmap_atomic in my driver.
My driver copies some pages coming from
user space to "kernel space kmalloc'ed memory".
I had this code running from 2.6.5 to 2.6.17 without any problems.
I have upgraded to 2.6.20.xx and this code fails to kmap_atomic.
I am running a uni processor 2 GRAM machine, 32bit.

Basically this is code does:

get_user_pages(page,...)

kmap_atomic(page,KM_USER0);
 .. copy and stuff
kunmap_atomic(page,KM_USER0)

I have also tried KM_USER1 and KM_SKB_SUNRPC_DATA.
I crash in arch/i386/highmem.c line 42:
  ...
  if (!pte_none(*(kmap_pte-idx)))
                  BUG();
..

To the best of my understanding ( from "see : understand the linux
kernel" page 310 ) , a different kernel component holds this window. A
fact which is quite strange in the case of KM_SKB_SUNRPC_DATA. I have
nothing that uses it.

1. Why kmap_atomic does not return NULL ?
2. Why am I failing only in high memory mappings ?

-- 
Raz

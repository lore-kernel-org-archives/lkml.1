Return-Path: <linux-kernel-owner+w=401wt.eu-S1758070AbYBVJqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbYBVJqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 04:46:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752931AbYBVJpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 04:45:54 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:51676 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbYBVJpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 04:45:53 -0500
Message-ID: <47BE99BC.2060707@ak.jp.nec.com>
Date: Fri, 22 Feb 2008 18:45:32 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Andrew G. Morgan" <morgan@kernel.org>
CC: greg@kroah.com, serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] exporting capability name/code pairs (final)
References: <47BE2A29.4010302@ak.jp.nec.com> <47BE8A10.3080103@kernel.org>
In-Reply-To: <47BE8A10.3080103@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew G. Morgan wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> KaiGai,
> 
> I've just tried to build this with a separate obj tree: make O=/path.../
> ~ the build failed as follows:
> 
> ~  CC      security/dummy.o
> ~  CC      security/inode.o
> ~  CAPS    security/cap_names.h
> /bin/sh: security/../scripts/mkcapnames.sh: No such file or directory
> make[3]: *** [security/cap_names.h] Error 127
> make[2]: *** [security] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2
> 
> when I replace $(src)/../scripts/...  with $(srctree)/scripts/... I get
> it to compile, but (x86_64) see this warning fly by:

Thanks for your pointed out.
I didn't know the macro, but it is suitable for my purpose.
I'll replace it on the next submitting.

> ~  CC      security/commoncap.o
> /home/morgan/gits/linux-2.6/security/commoncap.c: In function
> `capability_name_show':
> /home/morgan/gits/linux-2.6/security/commoncap.c:652: warning: cast from
> pointer to integer of different size

The entries under capability/names have its private data as integer value,
stored in kobj_attribute->data declared as void *.

One idea is casting it to 'unsigned long' and using "%ld" as the format.

I believe it is correct assumption that long type and pointers have
same width in the linux kernel. Please tell me, if it is wrong.

Thanks,
-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>

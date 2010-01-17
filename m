Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116Ab0AQQrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116Ab0AQQrN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 11:47:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839Ab0AQQrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 11:47:12 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:48915 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab0AQQrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 11:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Y+5yjcFGffxufJF+2E6vonizsS69QUO5DwqkD5JKqyx6LnIHVIfKlMyl/NXOeFlZ9o
         FwcILoDuPrLgHKo0aC3666KwVZXNe1CJVz0ZjNUVDgDtaD5hFP99weVMCUZc86q7g0Gy
         A3FjQn3oI2jZelXSQDhtdwNa07ABHxsqnZtAk=
MIME-Version: 1.0
Date: Sun, 17 Jan 2010 18:47:10 +0200
Message-ID: <af0693f01001170847r49083075hc538a42b6bcd65ab@mail.gmail.com>
Subject: /dev/mem implementation
From: Felix Rubinstein <felixru@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent kernels use CONFIG_STRICT_DEVMEM and CONFIG_X86_PAT
concerning the /dev/mem (/dev/kmem) so interchangeably one cannot
figure out what exactly does it mean to access the /dev/mem if both
CONFIG_STRICT_DEVMEM and CONFIG_X86_PAT are disabled.

It would be more logically to remove pat_enabled variable in
arch/x86/mm/pat.c and to make everything under CONFIG_X86_PAT define.
The same goes for phys_mem_access_prot_allowed function (from
arch/x86/mm/pat.c) even though CONFIG_X86_PAT is disabled.
To make the story worse there are four implementations of
range_is_allowed depending on how CONFIG_STRICT_DEVMEM and
CONFIG_X86_PAT are defined.


I see the motivation to limit the access to DRAM from root account
CONFIG_STRICT_DEVMEM by mmap'ing /dev/[k]mem but it's easily overruled
by simple char driver and implementing mmap of it's own totally
bypassing all limitations.

What do you think about it guy?
Appreciate it.

Thanks,
Felix R.

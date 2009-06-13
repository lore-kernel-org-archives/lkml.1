Return-Path: <linux-kernel-owner+w=401wt.eu-S1763103AbZFMQAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763103AbZFMQAb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761984AbZFMQAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:00:09 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:52495 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759825AbZFMQAI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:00:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fisd89aSyg0l7tsPi+50w3b0ju3jbnY9oiGUIt6MFx7AzpJgfJxqfm7CuGhB0iHaYh
         CbWkbLYZ0gF1sJIllZll4z5kx3fl0Qu6TjYSeHfDPCLPXdvWLwV8Jr/wg9ragVcdnh3P
         ZHbDWH8zzKiodFIx1h09J6i+y3raAiUkNnz/k=
MIME-Version: 1.0
In-Reply-To: <1244903447-23579-1-git-send-email-vapier@gentoo.org>
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 13 Jun 2009 11:59:50 -0400
Message-ID: <8bd0f97a0906130859h3cf1293era84ebd812a156328@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: uaccess: fix up local access_ok() usage
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 10:30, Mike Frysinger wrote:
> There's no reason that I can see to use the short __access_ok() form
> directly when the access_ok() is clearer in intent and for more people,
> expands to the same C code (i.e. always specify the first field -- access
> type).  Not all no-mmu systems lack memory protection, so the read/write
> could feasibly be checked.

hmm, and it also fixes the crazy amount of warnings you get otherwise
because the access_ok() expansion includes an unsigned long cast:
  CC [M]  fs/smbfs/request.o
In file included from
/usr/local/src/linux/linux-2.6/arch/blackfin/include/asm/uaccess.h:17,
                 from include/net/checksum.h:26,
                 from include/linux/skbuff.h:28,
                 from include/linux/ip.h:109,
                 from include/net/ip.h:27,
                 from fs/smbfs/smbiod.c:23:
include/asm-generic/uaccess.h: In function ‘copy_from_user’:
include/asm-generic/uaccess.h:247: warning: passing argument 1 of
‘_access_ok’ makes integer from pointer without a cast
include/asm-generic/uaccess.h: In function ‘copy_to_user’:
include/asm-generic/uaccess.h:257: warning: passing argument 1 of
‘_access_ok’ makes integer from pointer without a cast
include/asm-generic/uaccess.h: In function ‘strncpy_from_user’:
include/asm-generic/uaccess.h:281: warning: passing argument 1 of
‘_access_ok’ makes integer from pointer without a cast
include/asm-generic/uaccess.h: In function ‘clear_user’:
include/asm-generic/uaccess.h:319: warning: passing argument 1 of
‘_access_ok’ makes integer from pointer without a cast
-mike

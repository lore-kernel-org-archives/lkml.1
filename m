Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZECR2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZECR2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 13:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751997AbZECR1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 13:27:52 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:35066 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbZECR1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 13:27:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:date:x-google-sender-auth:message-id
         :subject:from:to:content-type:content-transfer-encoding;
        b=ufNkLgDqxmrlqvipXzelC+/zGLCDRCCPo5B+NgJtDrgjZQlWi+nsBD2BsJIoxeR/F1
         OUbG3OVI4uvyb2KC5m6WkfTB7anLRkF7Hw4g6qKqDLuS05ZzSgj7luFXpf2HmO0AURO5
         1jzcUECvXFJVubn+0lXotUU6Q0gkS8qoWay0k=
MIME-Version: 1.0
Reply-To: for.poige+linux@gmail.com
Date: Mon, 4 May 2009 01:27:51 +0800
X-Google-Sender-Auth: ec600f405c127675
Message-ID: <43d009740905031027w67b79433pa8fbc5ea24c12e11@mail.gmail.com>
Subject: Hi! How can I figure out amount of a process' "locked" memory?
From: Igor Podlesny <for.poige+linux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Sorry for asking here, but Googled no real answer. There's
/usr/bin/pmap with its man-page saying that "-x" option would tell
some "extended" info, but alas, it just outputing "-" instead of real
values.

	Tried to test that using simple C program named "ml.c":
	
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>

int main(int ac, char *av[])
{
    const size_t alloc_size = 45 * 1024 * 1024;
    char *buf = malloc(alloc_size);
    if (mlock(buf, alloc_size) ) {
        perror("mlock");
    }

    getchar();

    return (0);
}

	And pmap -x on that test process shows:

Address           Kbytes     RSS    Anon  Locked Mode   Mapping
0000000000400000       4       -       -       - r-x--  ml
0000000000600000       4       -       -       - rw---  ml
00007f9686000000   46080       -       -       - rw---    [ anon ]
00007f9688d00000    2048       -       -       - rw---    [ anon ]
[...]
----------------  ------  ------  ------  ------
total kB           66976       -       -       -

	It seems no information under corresponding /proc/PID can provide the
answer too, at least maps/smaps don't have something related to the
"locked" attribute.
	
	uname -rm: 2.6.29.2-64-1KHz-fst-ldbg x86_64
	/lib/libc.so.6: GNU C Library stable release version 2.9, by Roland
McGrath et al.

	Thanks in advance,

-- 
End of message. Next message?

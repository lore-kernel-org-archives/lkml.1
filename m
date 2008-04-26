Return-Path: <linux-kernel-owner+w=401wt.eu-S1756042AbYDZLi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbYDZLi6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 07:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752758AbYDZLir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 07:38:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:33179 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbYDZLir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 07:38:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=SLQ5qtHq0YCr475MlAhsEADgUek2hHiXzTe+Au+rIcmhor2tdd95F6pdbw9SG00wla3KyT2f9NrcijQjpLjDdJMkFsZnUbrrCu4Zz/oVIsLF4ozZoxxZ2hZtWaxWrVQJLiezUGkRqRSBgIGC3yw45Yw7Y6jmjT8SOL0XiqJAuuo=
Message-ID: <48131440.8090609@gmail.com>
Date: Sat, 26 Apr 2008 15:38:40 +0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Linux-kernel <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, thomas@winischhofer.net
Subject: [REGRESSEION] x86: allyesconfig fails with 'debug' symbol
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The last commit as of writing this regression report is
b1721d0da266b4af8cb4419473b4ca36206ab200, and I'm using Linus tree.

The allyesconfig build fails with the following error:

[dmitri.vorobiev@amber linux-2.6]$ make ARCH=i386 CROSS_COMPILE=i386-linux-gnu- 

[ ... skipped ... ]

  LD      vmlinux.o
drivers/built-in.o: In function `SiS_EnableBridge':
/home/dmitri.vorobiev/Projects/misc/zoo/src/linux-2.6/drivers/video/sis/init301.c:4352: multiple definition of `debug'
arch/x86/kernel/built-in.o:/home/dmitri.vorobiev/Projects/misc/zoo/src/linux-2.6/arch/x86/kernel/entry_32.S:766: first defined here
i386-linux-gnu-ld: Warning: size of symbol `debug' changed from 76 in arch/x86/kernel/built-in.o to 4 in drivers/built-in.o
make: *** [vmlinux.o] Error 1
[dmitri.vorobiev@amber linux-2.6]$

Although it is obvious what causes this problem, just now I have no time
to try to resolve this, so I decided to just report the failure.

Thanks,
Dmitri

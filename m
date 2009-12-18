Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZLRP2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZLRP2t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZLRP2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:28:48 -0500
Received: from web52907.mail.re2.yahoo.com ([206.190.49.17]:31895 "HELO
	web52907.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751221AbZLRP2q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:28:46 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=A8KLXUViOHPrm7PE3VVU33o/CIS6Y7O7cxr4q0YDi8nzPcW031PIHglPH0UuC1LYalSlSYVSKPs2CfQwKuDDC9Qrn4advjR0zCbChUf41IvrLPbEkoHhC3Bf/cC4w+9SLdykPmb5Ig7NAxV4VzT1vzzXHj1fy+nkcDEi/XpIRJM=;
Message-ID: <219280.97558.qm@web52907.mail.re2.yahoo.com>
X-YMail-OSG: dbZbgnYVM1nT89BjzenXx.iZPzq7xHzBmWXG3SEYVoPBg.63Av5Snu8NPj2LcZrzKqyiiJxxUR.gMOdTyv.C7n4qCS1VLDcykVUzRCIbdYL7k1n.QM_g.IEBNTL7J250jTTa7UfbNk3wWYId0YHHxphPoCvXo3z8eX06UtT9.rm3SU_I2HJSrSNq67wyqWilEkcqa5i_4o7l2dm1DNLGPM5yT0V1EWZe9MjXimomWo_W_4W2Uj7jfzxfQy3HjMMolUgd.LOw1JI5xaJCRk6m8W_Nhrx4qqkObD5YLNmdbkipG6mZKvuxygg50BSsKhfIvw9gA3_.hrZFWW1E.L613g--
X-Mailer: YahooMailClassic/9.0.19 YahooMailWebService/0.8.100.260964
Date: Fri, 18 Dec 2009 07:28:45 -0800 (PST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: [BUG] Kernel built for i586 chip crashes instantly at boot time (CMOV instructions)
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have been trying to build a 2.6.31.x kernel with Fedora 12's gcc compiler, and have discovered that this kernel crashes instantly at boot-time due to a pair of CMOV instructions in arch/x86/boot/compressed/misc.o. According to "make V=1", the command used to compile misc.c is:

  gcc -Wp,-MD,arch/x86/boot/compressed/.misc.o.d  -nostdinc -isystem /usr/lib/gcc/i686-redhat-linux/4.4.2/include -Iinclude -Iinclude2 -I/home/chris/LINUX/linux-2.6.31/include -I/home/chris/LINUX/linux-2.6.31/arch/x86/include -include include/linux/autoconf.h  -I/home/chris/LINUX/linux-2.6.31/arch/x86/boot/compressed -Iarch/x86/boot/compressed -D__KERNEL__ -m32 -D__KERNEL__ -O2 -fno-strict-aliasing -fPIC -DDISABLE_BRANCH_PROFILING -ffreestanding -fno-stack-protector   -D"KBUILD_STR(s)=#s" -D"KBUILD_BASENAME=KBUILD_STR(misc)"  -D"KBUILD_MODNAME=KBUILD_STR(misc)"  -c -o arch/x86/boot/compressed/misc.o /home/chris/LINUX/linux-2.6.31/arch/x86/boot/compressed/misc.c

which apparently uses gcc's default architecture. However, Fedora has recently changed its gcc default architecture from i586 to i686, and so I end up with a pair on invalid instructions in my kernel binary.

Cheers,
Chris


      

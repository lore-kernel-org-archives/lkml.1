Return-Path: <linux-kernel-owner+w=401wt.eu-S932366AbZJLPM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbZJLPM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756535AbZJLPMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:12:55 -0400
Received: from mamba.nagafix.co.uk ([194.145.196.68]:40899 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754644AbZJLPMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:12:54 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Oct 2009 11:12:54 EDT
DomainKey-Signature: a=rsa-sha1; s=mydk; d=nagafix.co.uk; c=simple; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:subject:
	x-enigmail-version:openpgp:content-type:content-transfer-encoding;
	b=Ds8SPZQ9lAF/MPq6ehKHnbNiE4RbCbDNftN4Ja5rTCPH46O9RXypcsuMfrtDrkkZ+
	2+DOrpzEZnL1YhmxJKMaO3GgcnLhoABRL0SY8fI5fchP1DH6wvP3gaFGuOKKdW1Yr7P
	U99THbuQBlMRDq1UdmP2uTEwUoQ4V2zBCzyO78o=
Message-ID: <4AD34542.7050500@nagafix.co.uk>
Date: Mon, 12 Oct 2009 22:03:30 +0700
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: 2.6.31.2 broke UML 64-bit build (2.6.31 was fine)
X-Enigmail-Version: 0.95.7
OpenPGP: id=F18AD6BB;
	url=http://users.nagafix.co.uk/~antoine/antoine.asc
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tar -jxf linux-2.6.31.2.tar.bz2
cd linux-2.6.31.2
cp ../.config ./
make ARCH=um
[...]
  MODPOST vmlinux.o
  GEN     .version
  CHK     include/linux/compile.h
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
/usr/lib/gcc/x86_64-pc-linux-gnu/4.1.2/../../../../x86_64-pc-linux-gnu/bin/ld:arch/um/kernel/vmlinux.lds:1:
ignoring invalid character `#' in expression
/usr/lib/gcc/x86_64-pc-linux-gnu/4.1.2/../../../../x86_64-pc-linux-gnu/bin/ld:arch/um/kernel/vmlinux.lds:1:
syntax error
collect2: ld returned 1 exit status
  KSYM    .tmp_kallsyms1.S
nm: '.tmp_vmlinux1': No such file
No valid symbol.
make: *** [.tmp_kallsyms1.S] Error 1

Sorry, not had time to bisect it.
Tested with gcc 4.1.2 and gcc 4.3.2
Use this config if yours does not exhibit the problem:
http://uml.devloop.org.uk/kernels/kernel64-2.6.31.config

Cheers
Antoine

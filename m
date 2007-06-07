Return-Path: <linux-kernel-owner+w=401wt.eu-S966033AbXFGA7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966033AbXFGA7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 20:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965299AbXFGA7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 20:59:01 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:53062 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbXFGA7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 20:59:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=EGEqB9iXqzefqZVLYQpiTBvetxlcjC79IfhazH/ZbH3aIridn///a4NJCu3dK23KrLsI5bMaL/UXGwZHZcxFspdnsgDvDbeDVpDRJkkAT2uLsBRPPDT1yAPaZY4pFCPepKG9AGh/ezbxh7Kcy7BVTPsNRvokJxtg2xD6KQcDoN4=
Message-ID: <8bd0f97a0706061758v492eb44y55bb3d6037acf668@mail.gmail.com>
Date: Wed, 6 Jun 2007 20:58:59 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: incorrect tracking of /proc/*/exe for overwritten running processes
Cc: dsd@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

looking at a simple program:
int main()
{
  if (fork()) return 0;
  printf("pid = %i\n", getpid());
  while (1) sleep(3600);
}

and where my / and /var/tmp are on the same partition:

# gcc test.c -o /usr/sbin/MOO
# /usr/sbin/MOO
pid = 17144
# readlink /proc/17144/exe
/usr/sbin/MOO

# gcc test.c -o /var/tmp/MOO
# mv /var/tmp/MOO /usr/sbin/MOO
# readlink /proc/17144/exe
/var/tmp/MOO (deleted)

i feel like the new exe link should actually read:
/usr/sbin/MOO (deleted)
otherwise people can easily get confused as they think their daemon
was started in /var/tmp/ and their machine was compromised

# uname -a
Linux vapier 2.6.21.3 #4 SMP PREEMPT Sat Jun 2 09:55:10 EDT 2007
x86_64 AMD Athlon(tm) 64 X2 Dual Core Processor 4200+ AuthenticAMD
GNU/Linux
-mike

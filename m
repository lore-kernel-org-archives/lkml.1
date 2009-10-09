Return-Path: <linux-kernel-owner+w=401wt.eu-S1761131AbZJISWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761131AbZJISWp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 14:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbZJISWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 14:22:44 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:49252 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZJISWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 14:22:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=UMb8P6RcFiXbYLTXm+b58UMh74YMn5Z6evNaGpm11UPWx//j0Z/8eRAn/sj4zGn9hP
         1j91HhX33tQEop+Q7EodnIuNB50bEUgm55AfAD07dNxKUBENx5pNAqiopfVtOMPumQC3
         319FqIgM++o1jdA00UVeF8DlnC8AuVZo326WY=
MIME-Version: 1.0
Date: Fri, 9 Oct 2009 13:22:06 -0500
Message-ID: <a3e829d20910091122p3c56acf6h975be820e555d400@mail.gmail.com>
Subject: printk() not outputting
From: Richard Langly <richard.ringo.langly@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got a problem making it hard for me to debug. For some reason, my
printk()'s aren't putting anything out to my /var/log/messages file. I
am running X so, as I understand it, messages won't appear in the
terminals where I insmod the module. But they should appear in
/var/log/messages.

If I load my test module, I do get a message from /var/log/messages saying ....

Oct  3 14:50:04 Tux sudo:   whisper : TTY=pts/12 ;
PWD=/home/whisper/test-mod/kernel/net/tm ; USER=root ;
COMMAND=/sbin/insmod mymod.ko

My problem appears as simple as this.
static int __init my_init(void) {
    printk(KERN_CRIT "my_init ...\n");

    // ...

    return 0;
}

static void __exit my_exit(void) {
    printk(KERN_INFO "my_exit ...\n");
}

Also, the values in my /proc/sys/kernel/printk file are:
8 4 1 7

So I changed the first value to 8, and I still don't see messages in
my /var/log/messages file, nor using dmesg.

When I load the module, it's just this ...
make
sudo depmod -a
sudo insmod ./mymod.ko

And I don't see anything in my syslog-ng.conf that would prevent this.

Any help much appreciated.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbZKFAyd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbZKFAyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:54:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbZKFAyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:54:32 -0500
Received: from mail-iw0-f180.google.com ([209.85.223.180]:65468 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbZKFAya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:54:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=G7XBdYXzGWMGD5UP+Su4fBsImcqUBbztiL5l7aDzIbtWpjpHgTexGxzDvBBUrkTtEz
         8XCJRPyR+RiOGge3V7gWuZal87adT8PBVaD/Cy/Yszp0aUxIss1EUouXoW9qT/O5aocq
         OrZIfsUDCSekQAMiAVOADCIgPmI0+jyMf9TJ0=
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 5 Nov 2009 16:54:14 -0800
Message-ID: <43e72e890911051654i19c18bf3nd397662ed79712c4@mail.gmail.com>
Subject: Using netconsole and getting double prints
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting double prints when using netconsole. This used to happen
to me and then I just enable debugging log level manually (dmesg -n 8)
but now no matter what I try I always get double prints.

For example:

[   23.425448] console [netcon0] enabled
[   23.425567] netconsole: network logging started
[   23.425448] console [netcon0] enabled
[   23.425567] netconsole: network logging started
[   32.856073] eth0: no IPv6 routers present
[   32.856073] eth0: no IPv6 routers present
[   66.307342] kmemleak: 6 new suspected memory leaks (see
/sys/kernel/debug/kmemleak)
[   66.307342] kmemleak: 6 new suspected memory leaks (see
/sys/kernel/debug/kmemleak)

Instead of dmesg -8 I'm now using ignore_loglevel as a kernel
parameter but I still get double prints. This also happens if I use
"debug" as a kernel parameter instead.

The netconsole is set up on the dev box as follows through an /etc/rc.local

dhclient eth0
IP=192.168.2
# sudo dmesg -n 8
modprobe netconsole netconsole=@/eth0,6666@${IP}/
exit 0

I capture my data with netcat script (I call it netlog):

#!/bin/bash
echo "You should now run in another window: tail -f $HOME/log"
while true; do
	/bin/nc -u -l -p 6666 >> $HOME/log
done

This also just doesn't work if I run the nc manually without a redirect:

while true; do /bin/nc -u -l -p 6666; done

Any ideas?

  Luis

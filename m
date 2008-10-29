Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbYJ2N1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbYJ2N1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 09:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753802AbYJ2N1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 09:27:10 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1065 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbYJ2N1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 09:27:09 -0400
Date: Wed, 29 Oct 2008 14:27:06 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6.26] kobject_add_internal failed for 2:0 with -EEXIST /
	unable to handle kernel NULL pointer dereference in
	sysfs_create_link
Message-ID: <20081029132704.GS11214@vanheusden.com>
References: <20081028151157.GI11214@vanheusden.com> <ac3eb2510810281607o19266977l4c77d3d3ab4bb849@mail.gmail.com> <20081029094041.GO11214@vanheusden.com> <ac3eb2510810290525h1579bad8i4836ce1291d9022@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2510810290525h1579bad8i4836ce1291d9022@mail.gmail.com>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Wed Oct 29 12:57:18 CET 2008
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a
	key-signing at www.biglumber.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> > While running my http://vanheusden.com/pyk/ script (which randomly
> >> > inserts and removes modules) I triggered the folllowing oops in a 2.6.26
> >> > kernel on an IBM xSeries 260. This oops (in fact no oops at all) did not
> >> > get triggered in a 2.6.18 kernel on that system.
> >> >
> >> > [   42.507375] FDC 0 is a National Semiconductor PC87306
> >> > [   42.509057] kobject_add_internal failed for 2:0 with -EEXIST, don't try to register things with the same name in the same directory.
> >> > [   42.509291] Pid: 5301, comm: modprobe Not tainted 2.6.26-1-amd64 #1
> >> > [   42.509431]
> >> > [   42.509433] Call Trace:
> >> > [   42.509685]  [<ffffffff8031b031>] kobject_add_internal+0x13f/0x17e
...
> >> > [   42.511519]  [<ffffffff8027d23b>] bdi_register+0x57/0xb4
> >>
> >> Looks like bdi sees two devices with the same devnum, or didn't
> >> cleanup an old entry. What does: ls -l "/sys/class/bdi/" print?
> >
> > The following:
> > folkert@debiantesthw:~$ ls -l /sys/class/bdi/
> > drwxr-xr-x 3 root root 0 2008-10-28 18:32 2:0
> > drwxr-xr-x 3 root root 0 2008-10-28 18:32 2:1
> 
> Oh, you are running the old sysfs layout without symlinks. Care to
> tell where the "device" link in these directories points to?

None exist:
folkert@debiantesthw:~$ ls -la /sys/class/bdi/*/device
ls: cannot access /sys/class/bdi/*/device: No such file or directory


Folkert van Heusden

-- 
Multitail es una herramienta flexible que permite visualizar los "log
file" y seguir la ejecución de comandos. Permite filtrar, añadir
colores, combinar archivos, la visualización de diferencias (diff-
view), etc.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com

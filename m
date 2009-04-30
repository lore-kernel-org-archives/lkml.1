Return-Path: <linux-kernel-owner+w=401wt.eu-S1762067AbZD3Iap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762067AbZD3Iap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 04:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762024AbZD3IaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 04:30:10 -0400
Received: from main.gmane.org ([80.91.229.2]:45385 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762013AbZD3IaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 04:30:08 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: usbutils 0.81 release
Date: Thu, 30 Apr 2009 08:31:01 +0200
Organization: m
Message-ID: <871vrar6u2.fsf@nemi.mork.no>
References: <20090427193532.GA2948@kroah.com>
	<8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com>
	<20090429180735.GA29812@kroah.com>
	<8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com>
	<ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com>
	<20090429191841.GA1598@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: nemi.mork.no
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/22.2 (gnu/linux)
Cancel-Lock: sha1:Qb7KRPuMIOnigVnm4WW/D/a2xIk=
Cc: linux-usb@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh
<hmh@hmh.eng.br> writes:

> Debian places it in /var/lib/usbids/ for a good reason.  So does Ubuntu.
> Both have working "update-usbids" scripts (might be the one from upstream,
> or something different).  They also have the original file in /usr/share, I
> don't know if usbutils was changed to check /var first then /usr, or what.

No.  They place a symlink from /usr/share to /var/lib:

bjorn@nemi:~$ ls -l /usr/share/misc/usb.ids 
lrwxrwxrwx 1 root root 25 2009-01-24 01:36 /usr/share/misc/usb.ids -> /var/lib/usbutils/usb.ids
bjorn@nemi:~$ dpkg -S /usr/share/misc/usb.ids
usbutils: /usr/share/misc/usb.ids

The symlink is probably there for compatibility with other (possibly
non-Debian) utilities.  Debian usbutils does not use the /usr/share path
itself:

bjorn@nemi:~$ strings /usr/sbin/lsusb |grep usb.ids
./usb.ids
./usb.ids.gz
/var/lib/usbutils/usb.ids
/var/lib/usbutils/usb.ids.gz

However, looks like the Debian hal uses it.  That's probably the main
reason for the symlink:

bjorn@nemi:~$ strings /usr/sbin/hald |grep usb.ids
/usr/share/misc/usb.ids
Couldn't stat usb.ids file '%s', errno=%d: %s
Couldn't open usb.ids file '%s', errno=%d: %s
Couldn't mmap usb.ids file '%s', errno=%d: %s
usb_ids_load


Bjørn


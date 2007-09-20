Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbXITLNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbXITLNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 07:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751456AbXITLNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 07:13:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63772 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbXITLNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 07:13:38 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: sys_chroot+sys_fchdir Fix
To: David Newall <david@davidnewall.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Bill Davidsen <davidsen@tmr.com>, majkls <majkls@prepere.com>,
       bunk@fs.tum.de, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Thu, 20 Sep 2007 13:13:20 +0200
References: <952DN-83o-31@gated-at.bofh.it> <954cl-29C-3@gated-at.bofh.it> <95ctn-74b-15@gated-at.bofh.it> <95cMH-7um-19@gated-at.bofh.it> <95gdA-4OZ-7@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1IYJyC-0000iq-TR@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19SQiyLhLNjDCz2+pPL4zk5LDE92Gd6TYdfutX
 7CBGJPOSAcYDXuFJki181uJC58+Ur+k70ciYZKWqBOI6RZSTrv
 kp7xap2u0/qyNJAqKDVWA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Newall <david@davidnewall.com> wrote:

>> Normal users cannot use chroot() themselves so they can't use chroot to
>> get back out
> 
> I think Bill is right, that this is to fix a method that non-root
> processes can use to escape their chroot. The exploit, which is
> documented in chroot(2)*, is to chdir("..") your way out. Who'd have
> thought it? Only root can do that, but even that seems wrong. Chroot
> should be chroot and that should be the end of it.

chroot with having open directories outside the chroot is a convenience
feature, allowing e.g. to install programs into a different root while
opening the archives from another root tree. Only if there is a working
capability system preventing root from accessing the hardware*, a chroot
may become a security feature.

Off cause having the new fchdir, you might run "chroot /var/foo 3< /" in
order to pass a dir filehandle and compromise your own security, but this
is nothin a system should protect against.

The only problem I'm concerned about is passing a file descriptor to a
privileged, compromised process using an abstract unix socket. This combines
two different privileges, possibly increasing the impact of the attack.
I think it may be enough to not allow passing directory fds if the two
processes have different device/inode/namespace, but I'm not sure about
device fds.


*) chmod u+s binary; su nobody; exec binary; mount tmpfs /; mknod dev_mem
   should be enough to void most root-in-chroot setups. Very untested.
-- 
Funny quotes:
26. If you take an Oriental person and spin him around several times, does he
    become disoriented?
Friß, Spammer: hrzoi8.sT@gYjoOs.7eggert.dyndns.org zq@u1kq.7eggert.dyndns.org

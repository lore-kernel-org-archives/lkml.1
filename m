Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbXE0Ch3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbXE0Ch3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 22:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbXE0ChR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 22:37:17 -0400
Received: from h80ad2262.async.vt.edu ([128.173.34.98]:37348 "EHLO
	h80ad2262.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbXE0ChP (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 22:37:15 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Toshiharu Harada <haradats@gmail.com>, James Morris <jmorris@namei.org>,
       casey@schaufler-ca.com, Andreas Gruenbacher <agruen@suse.de>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 01/41] Pass struct vfsmount to the inode_create LSM hook
In-Reply-To: Your message of "Sat, 26 May 2007 22:10:34 EDT."
             <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com>
From: Valdis.Kletnieks@vt.edu
References: <309300.41401.qm@web36615.mail.mud.yahoo.com> <B4A3C582-68F9-4077-B058-03B79A5577EB@mac.com> <Line.LNX.4.64.0705261442000.23020@d.namei> <9d732d950705261608j4bc72cd4s4378df9848101c84@mail.gmail.com>
            <EC769668-ED57-4D6D-80B2-1BFD039E113C@mac.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1180233422_6097P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 26 May 2007 22:37:02 -0400
Message-ID: <12000.1180233422@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1180233422_6097P
Content-Type: text/plain; charset=us-ascii

On Sat, 26 May 2007 22:10:34 EDT, Kyle Moffett said:
> On May 26, 2007, at 19:08:56, Toshiharu Harada wrote:

> > (1) Object labeling has a assumption that labels are always  
> > properly defined and maintained. This can not be easily achieved.
> 
> That's a circular argument, and a fairly trivial one at that.  If you  
> can't properly manage your labels, then how do you expect any  
> security at all? 

Unfortunately, it's not at all as simple as all that. Toshiharu is quite
correct that it isn't always easy to actually implement.  Consider how
many ad-croc usages of 'restorecon' are needed to get a Fedora SELinux box
through rc.sysinit:

% grep restorecon /etc/rc.sysinit
if [ -n "$SELINUX_STATE" -a -x /sbin/restorecon ] && LC_ALL=C fgrep -q " /dev " /proc/mounts ; then
        /sbin/restorecon  -R /dev 2>/dev/null
    REBOOTFLAG=`restorecon -v /sbin/init`
[ -n "$SELINUX_STATE" ] && restorecon /dev/pts >/dev/null 2>&1
[ -n "$SELINUX_STATE" ] && restorecon /dev/mapper /dev/mapper/control >/dev/null 2>&1
                        [ -n "$SELINUX_STATE" -a -e "$path" ] && restorecon -R "$path"
                                [ -n "$SELINUX_STATE" -a -e "$path" ] && restorecon -R "$path"
                                [ -n "$SELINUX_STATE" -a -e "$path" ] && restorecon -R "$path"
   restorecon /etc/mtab /etc/ld.so.cache /etc/blkid/blkid.tab /etc/resolv.conf >/dev/null 2>&1
[ -n "$SELINUX_STATE" ] && restorecon /tmp
[ -n "$SELINUX_STATE" ] && restorecon /tmp/.ICE-unix >/dev/null 2>&1

And that's just getting the system up to single-user.  Things like sendmail
and sshd require more restorecon handholding in their rc.init files.

Or just look at the creeping horror that is 'restorecond' (in particular,
consider that the default restorcond.conf contains the strings '~/public_html'
and '~/.mozilla/plugins/libflashplayer.so'.  Yee. Frikkin. Hah. ;)


--==_Exmh_1180233422_6097P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGWO7OcC3lWbTT17ARAuX+AKCzQq3vKWrFhi5JiSqfaIpn44qTdACgvv7c
7WqVCgRZXs4cyW97MVEXXps=
=D7Bd
-----END PGP SIGNATURE-----

--==_Exmh_1180233422_6097P--

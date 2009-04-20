Return-Path: <linux-kernel-owner+w=401wt.eu-S1752244AbZDTQ0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244AbZDTQ0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 12:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbZDTQZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 12:25:57 -0400
Received: from atreides.gradator.net ([212.85.155.42]:42223 "EHLO
	atreides.gradator.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZDTQZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 12:25:56 -0400
X-Greylist: delayed 336 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Apr 2009 12:25:55 EDT
Date: Mon, 20 Apr 2009 18:20:18 +0200
From: Sylvain Rochet <gradator@gradator.net>
To: linux-kernel@vger.kernel.org
Message-ID: <20090420162017.GA28079@gradator.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: gradator@atreides.gradator.net
Subject: 2.6.28.9: EXT3/NFS inodes corruption
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:51:29 +0000)
X-SA-Exim-Scanned: Yes (on atreides.gradator.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


We(TuxFamily) are having some inodes corruptions on a NFS server.


So, let's start with the facts.


=3D=3D=3D=3D NFS Server

Linux bazooka 2.6.28.9 #1 SMP Mon Mar 30 12:58:22 CEST 2009 x86_64 GNU/Linux

root@bazooka:/usr/src# grep EXT3 /boot/config-2.6.28.9=20
CONFIG_EXT3_FS=3Dy
CONFIG_EXT3_FS_XATTR=3Dy
CONFIG_EXT3_FS_POSIX_ACL=3Dy
CONFIG_EXT3_FS_SECURITY=3Dy

root@bazooka:/usr/src# grep NFS /boot/config-2.6.28.9=20
CONFIG_NFS_FS=3Dy
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
# CONFIG_NFS_V4 is not set
CONFIG_NFSD=3Dy
CONFIG_NFSD_V2_ACL=3Dy
CONFIG_NFSD_V3=3Dy
CONFIG_NFSD_V3_ACL=3Dy
# CONFIG_NFSD_V4 is not set
CONFIG_NFS_ACL_SUPPORT=3Dy
CONFIG_NFS_COMMON=3Dy

  =3D=3D> We upgraded from 2.6.26.5 to 2.6.28.9, problem's still here


/dev/md10 on /data type ext3 (rw,noatime,nodiratime,grpquota,commit=3D5,dat=
a=3Dordered)

  =3D=3D> We used data=3Dwriteback, we fallback to data=3Dordered,
      problem's still here


# /etc/exports
/data                   *(rw,no_root_squash,async,no_subtree_check)
=2E.. and lots of exports of subdirs of /data, exported the same way


Process about NFS, on the NFS server.

root@bazooka:~# ps aux | grep -E '(nfsd]|lockd]|statd|mountd|idmapd|rquotad=
|portmap)$'
daemon    1226  0.0  0.0   4824   452 ?        Ss   Apr11   0:06 /sbin/port=
map
root      1703  0.0  0.0      0     0 ?        S<   01:29   0:09 [lockd]
root      1704  0.3  0.0      0     0 ?        D<   01:29   3:29 [nfsd]
root      1705  0.3  0.0      0     0 ?        S<   01:29   3:34 [nfsd]
root      1706  0.3  0.0      0     0 ?        S<   01:29   3:32 [nfsd]
root      1707  0.3  0.0      0     0 ?        S<   01:29   3:30 [nfsd]
root      1708  0.3  0.0      0     0 ?        D<   01:29   3:43 [nfsd]
root      1709  0.3  0.0      0     0 ?        D<   01:29   3:43 [nfsd]
root      1710  0.3  0.0      0     0 ?        D<   01:29   3:39 [nfsd]
root      1711  0.3  0.0      0     0 ?        D<   01:29   3:42 [nfsd]
root      1715  0.0  0.0   5980   576 ?        Ss   01:29   0:00 /usr/sbin/=
rpc.mountd
statd     1770  0.0  0.0   8072   648 ?        Ss   Apr11   0:00 /sbin/rpc.=
statd
root      1776  0.0  0.0  23180   536 ?        Ss   Apr11   0:00 /usr/sbin/=
rpc.idmapd
root      1785  0.0  0.0   6148   552 ?        Ss   Apr11   0:00 /usr/sbin/=
rpc.rquotad

  =3D=3D> We used to run tenths of nfsd daemons, we fallback to 8,
      the default, problem's still here
  =3D=3D> There are some 'D' processes because of a running data-check


Block device health:

Apr  3 00:28:20 bazooka kernel: md: data-check of RAID array md10
Apr  3 05:11:59 bazooka kernel: md: md10: data-check done.

Apr  5 01:06:01 bazooka kernel: md: data-check of RAID array md10
Apr  5 05:49:42 bazooka kernel: md: md10: data-check done.

Apr 20 16:27:33 bazooka kernel: md: data-check of RAID array md10

md10 : active raid6 sda[0] sdl[11] sdk[10] sdj[9] sdi[8] sdh[7] sdg[6] sdf[=
5] sde[4] sdd[3] sdc[2] sdb[1]
      1433738880 blocks level 6, 64k chunk, algorithm 2 [12/12] [UUUUUUUUUU=
UU]
      [=3D=3D=3D=3D=3D=3D>..............]  check =3D 30.1% (43176832/143373=
888) finish=3D208.1min speed=3D8020K/sec

  =3D=3D> Everything seems fine


# df -m
/dev/md10              1378166     87170   1290997   7% /data

# df -i
/dev/md10            179224576 3454822 175769754    2% /data



=3D=3D=3D=3D NFS Clients

6x Linux cognac 2.6.28.9-grsec #1 SMP Sun Apr 12 13:06:49 CEST 2009 i686 GN=
U/Linux
5x Linux martini 2.6.28.9-grsec #1 SMP Tue Apr 14 00:01:30 UTC 2009 i686 GN=
U/Linux
2x Linux armagnac 2.6.28.9 #1 SMP Tue Apr 14 08:59:12 CEST 2009 i686 GNU/Li=
nux

grad@armagnac:~$ grep NFS /boot/config-2.6.28.9=20
CONFIG_NFS_FS=3Dy
CONFIG_NFS_V3=3Dy
CONFIG_NFS_V3_ACL=3Dy
# CONFIG_NFS_V4 is not set
CONFIG_NFSD=3Dy
CONFIG_NFSD_V2_ACL=3Dy
CONFIG_NFSD_V3=3Dy
CONFIG_NFSD_V3_ACL=3Dy
# CONFIG_NFSD_V4 is not set
CONFIG_NFS_ACL_SUPPORT=3Dy
CONFIG_NFS_COMMON=3Dy

  =3D=3D> We upgraded from 2.6.23.16 and 2.6.24.2 (yeah, vmsplice upgrade=
=20
;-) to 2.6.28.9, problem's still here


x.x.x.x:/data/... on /data/... type nfs (rw,noexec,nosuid,nodev,async,hard,=
nfsvers=3D3,udp,intr,rsize=3D32768,wsize=3D32768,timeo=3D20,addr=3Dx.x.x.x)

  =3D=3D> All NFS exports are mounted this way, sometimes with the 'sync'=
=20
      option, like web sessions.
  =3D=3D> Those are often mounted from outside of chroots into chroots,=20
      useless detail I think


Process about NFS, on the NFS clients.

root@cognac:~# ps aux | grep -E '(nfsd]|lockd]|statd|mountd|idmapd|rquotad|=
portmap)$'
daemon     349  0.0  0.0   1904   536 ?        Ss   Apr12   0:00 /sbin/port=
map
statd      360  0.0  0.1   3452  1152 ?        Ss   Apr12   0:00 /sbin/rpc.=
statd
root      1190  0.0  0.0      0     0 ?        S<   Apr12   0:00 [lockd]



=3D=3D=3D=3D So, now, going into the problem

The kernel log is not really nice with us, here on the NFS Server:

Mar 22 06:47:14 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Un=
recognised inode hash code 52
Mar 22 06:47:14 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Co=
rrupt dir inode 40420228, running e2fsck is recommended.
Mar 22 06:47:16 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Un=
recognised inode hash code 52
Mar 22 06:47:16 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Co=
rrupt dir inode 40420228, running e2fsck is recommended.
Mar 22 06:47:19 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Un=
recognised inode hash code 52
Mar 22 06:47:19 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Co=
rrupt dir inode 40420228, running e2fsck is recommended.
Mar 22 06:47:19 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Un=
recognised inode hash code 52
Mar 22 06:47:19 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Co=
rrupt dir inode 40420228, running e2fsck is recommended.
Mar 22 06:47:19 bazooka kernel: EXT3-fs warning (device md10): dx_probe: Un=
recognised inode hash code 52
And so on...

And more recently...
Apr  2 22:19:01 bazooka kernel: EXT3-fs warning (device md10): ext3_unlink:=
 Deleting nonexistent file (40780223), 0
Apr  2 22:19:02 bazooka kernel: EXT3-fs warning (device md10): ext3_unlink:=
 Deleting nonexistent file (40491685), 0
Apr 11 07:23:02 bazooka kernel: EXT3-fs warning (device md10): ext3_unlink:=
 Deleting nonexistent file (174301379), 0
Apr 20 08:13:32 bazooka kernel: EXT3-fs warning (device md10): ext3_unlink:=
 Deleting nonexistent file (54942021), 0


Not much stuff in the kernel log of NFS clients, history is quite lost,=20
but we got some of them:

=2E...................: NFS: Buggy server - nlink =3D=3D 0!


=3D=3D Going deeper into the problem

Something like that is quite common:

root@bazooka:/data/...# ls -la
total xxx
drwxrwx--- 2 xx    xx        4096 2009-04-20 03:48 .
drwxr-xr-x 7 root  root      4096 2007-01-21 13:15 ..
-rw-r--r-- 1 root  root         0 2009-04-20 03:48 access.log
-rw-r--r-- 1 root  root  70784145 2009-04-20 00:11 access.log.0
-rw-r--r-- 1 root  root   6347007 2009-04-10 00:07 access.log.10.gz
-rw-r--r-- 1 root  root   6866097 2009-04-09 00:08 access.log.11.gz
-rw-r--r-- 1 root  root   6410119 2009-04-08 00:07 access.log.12.gz
-rw-r--r-- 1 root  root   6488274 2009-04-07 00:08 access.log.13.gz
?--------- ?    ?     ?         ?                ? access.log.14.gz
?--------- ?    ?     ?         ?                ? access.log.15.gz
?--------- ?    ?     ?         ?                ? access.log.16.gz
?--------- ?    ?     ?         ?                ? access.log.17.gz
-rw-r--r-- 1 root  root   6950626 2009-04-02 00:07 access.log.18.gz
?--------- ?    ?     ?         ?                ? access.log.19.gz
-rw-r--r-- 1 root  root   6635884 2009-04-19 00:11 access.log.1.gz
?--------- ?    ?     ?         ?                ? access.log.20.gz
?--------- ?    ?     ?         ?                ? access.log.21.gz
?--------- ?    ?     ?         ?                ? access.log.22.gz
?--------- ?    ?     ?         ?                ? access.log.23.gz
?--------- ?    ?     ?         ?                ? access.log.24.gz
?--------- ?    ?     ?         ?                ? access.log.25.gz
?--------- ?    ?     ?         ?                ? access.log.26.gz
-rw-r--r-- 1 root  root   6616546 2009-03-24 00:07 access.log.27.gz
?--------- ?    ?     ?         ?                ? access.log.28.gz
?--------- ?    ?     ?         ?                ? access.log.29.gz
-rw-r--r-- 1 root  root   6671875 2009-04-18 00:12 access.log.2.gz
?--------- ?    ?     ?         ?                ? access.log.30.gz
-rw-r--r-- 1 root  root   6347518 2009-04-17 00:10 access.log.3.gz
-rw-r--r-- 1 root  root   6569714 2009-04-16 00:12 access.log.4.gz
-rw-r--r-- 1 root  root   7170750 2009-04-15 00:11 access.log.5.gz
-rw-r--r-- 1 root  root   6676518 2009-04-14 00:12 access.log.6.gz
-rw-r--r-- 1 root  root   6167458 2009-04-13 00:11 access.log.7.gz
-rw-r--r-- 1 root  root   5856576 2009-04-12 00:10 access.log.8.gz
-rw-r--r-- 1 root  root   6644142 2009-04-11 00:07 access.log.9.gz


root@bazooka:/data/...# cat *      # output filtered, only errors
cat: access.log.14.gz: Stale NFS file handle
cat: access.log.15.gz: Stale NFS file handle
cat: access.log.16.gz: Stale NFS file handle
cat: access.log.17.gz: Stale NFS file handle
cat: access.log.19.gz: Stale NFS file handle
cat: access.log.20.gz: Stale NFS file handle
cat: access.log.21.gz: Stale NFS file handle
cat: access.log.22.gz: Stale NFS file handle
cat: access.log.23.gz: Stale NFS file handle
cat: access.log.24.gz: Stale NFS file handle
cat: access.log.25.gz: Stale NFS file handle
cat: access.log.26.gz: Stale NFS file handle
cat: access.log.28.gz: Stale NFS file handle
cat: access.log.29.gz: Stale NFS file handle
cat: access.log.30.gz: Stale NFS file handle


"Stale NFS file handle"... on the NFS Server... hummm...


=3D=3D Other facts

fsck.ext3 fixed the filesystem but didn't fix the problem.

mkfs.ext3 didn't fix the problem either.

It only concerns files which have been recently modified, logs, awstats=20
hashfiles, websites caches, sessions, locks, and such.

It mainly happens to files which are created on the NFS server itself,=20
but it's not a hard rule.

Keeping inodes into servers' cache seems to prevent the problem to happen.
( yeah, # while true ; do ionice -c3 find /data -size +0 > /dev/null ; done=
 )


Hummm, it seems to concern files which are quite near to each others,=20
let's check that:

Let's build up an inode "database"

# find /data -printf '%i %p\n' > /root/inodesnumbers


Let's check how inodes numbers are distributed:

# cat /root/inodesnumbers | perl -e 'use Data::Dumper; my @pof; while(<>){m=
y ( $inode ) =3D ( $_ =3D~ /^(\d+)/ ); my $hop =3D int($inode/1000000); $po=
f[$hop]++; }; for (0 .. $#pof) { print $_." =3D ".($pof[$_]/10000)."%\n" }'
[... lot of quite unused inodes groups]
53 =3D 3.0371%
54 =3D 26.679%     <=3D mailboxes
55 =3D 2.7026%
[... lot of quite unused inodes groups]
58 =3D 1.3262%
59 =3D 27.3211%    <=3D mailing lists archives
60 =3D 5.5159%
[... lot of quite unused inodes groups]
171 =3D 0.0631%
172 =3D 0.1063%
173 =3D 27.2895%   <=3D
174 =3D 44.0623%   <=3D
175 =3D 45.6783%   <=3D websites files
176 =3D 45.8247%   <=3D
177 =3D 36.9376%   <=3D
178 =3D 6.3294%
179 =3D 0.0442%

Hummm, all the files are using the same inodes "groups".
  (groups of a million of inodes)

We use to fix broken folders by moving them to a quarantine folder and=20
by restoring disappeared files from the backup.

So, let's check corrupted inodes number from the quarantine folder:

root@bazooka:/data/path/to/rep/of/quarantine/folders# find . -mindepth 1 -m=
axdepth 1 -printf '%i\n' | sort -n
174293418
174506030
174506056
174506073
174506081
174506733
174507694
174507708
174507888
174507985
174508077
174508083
176473056
176473062
176473064

Humm... those are quite near to each other 17450... 17647... and are of=20
course in the most used inodes "groups"...


Open question: are NFS clients can steal inodes numbers from each others ?


I am not sure whether my bug report is good, feel free to ask questions ;)

Best regards,
Sylvain

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ7KDBDFub3qtEsS8RAmojAKCGITmg8gPEUUjXXOKejX57oGktbACfdpMD
ZpQVHbuO3xiRCQ5VC4cLvpM=
=WEVM
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--

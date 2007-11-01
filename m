Return-Path: <linux-kernel-owner+w=401wt.eu-S1758509AbXKAM0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509AbXKAM0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 08:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbXKAM0A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 08:26:00 -0400
Received: from iucha.net ([209.98.146.184]:57624 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbXKAMZ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 08:25:59 -0400
Date: Thu, 1 Nov 2007 07:25:58 -0500
From: Florin Iucha <florin@iucha.net>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Message-ID: <20071101122558.GX25561@iucha.net>
References: <20071028152428.GJ7918@iucha.net> <E1ImlvH-0003YH-Qf@localhost> <20071030114250.GL25561@iucha.net> <E1ImpbK-0000l3-1u@localhost> <20071031000242.GP25561@iucha.net> <20071031035245.GQ25561@iucha.net> <E1In7S9-0001rv-NO@localhost> <20071031121606.GR25561@iucha.net> <20071031175318.GU25561@iucha.net> <E1InUH6-0001vE-1Y@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RUh7Gb6wQL2PrpWP"
Content-Disposition: inline
In-Reply-To: <E1InUH6-0001vE-1Y@localhost>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--RUh7Gb6wQL2PrpWP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 01, 2007 at 03:15:32PM +0800, Fengguang Wu wrote:
> On Wed, Oct 31, 2007 at 12:53:18PM -0500, Florin Iucha wrote:
> > This patch does not fix anything for me.  Even such light use of the
> > reiserfs filesystem as pulling the linux-2.6 git tree updates caused
> > one CPU to go to 75% iowait.
> =20
> Thank you, Florin. Could you provide more details about sda7, such as
> the mount option and output of `reiserfstune /dev/sda7`? I'll try to
> reproduce it before asking for your help.

Fengguang,

root@zeus:~# mount | grep sda7
/dev/sda7 on /scratch type reiserfs (rw,noatime)
root@zeus:~# df -h /scratch/
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda7              38G   32G  5.7G  85% /scratch
root@zeus:~# umount /dev/sda7
root@zeus:~# reiserfstune /dev/sda7
reiserfstune: Journal device has not been specified. Assuming journal is on=
 the main device (/dev/sda7).

Current parameters:

Filesystem state: consistent

/scratch: Reiserfs super block in block 16 on 0x807 of format 3.6 with stan=
dard journal
Count of blocks on the device: 9765504
Number of bitmaps: 299
Blocksize: 4096
Free blocks (count of blocks - used [journal, bitmaps, data, reserved] bloc=
ks): 1471399
Root block: 2359332
Filesystem is clean
Tree height: 5
Hash function used to sort names: "r5"
Objectid map size 916, max 972
Journal parameters:
        Device [0x0]
        Magic [0x31037e64]
        Size 8193 blocks (including 1 for journal header) (first block 18)
        Max transaction length 1024 blocks
        Max batch size 900 blocks
        Max commit age 30
Blocks reserved by journal: 0
Fs state field: 0x0:
sb_version: 2
inode generation number: 5856766
UUID: a0191e80-be6e-47f6-8fd0-047e2d763a4a
LABEL: /scratch
Set flags in SB:
        ATTRIBUTES CLEAN

And for bonus points:
###########
reiserfsck --check started at Thu Nov  1 07:09:56 2007
###########
Replaying journal..
Reiserfs journal '/dev/sda7' in blocks [18..8211]: 0 transactions replayed
Checking internal tree..finished                              =20
Comparing bitmaps..finished
Checking Semantic tree:
finished                                                                   =
   =20
No corruptions found
There are on the filesystem:
        Leaves 247231
        Internal nodes 1570
        Directories 11330
        Other files 722878
        Data block pointers 8040675 (3880 of them are zero)
        Safe links 0
###########
reiserfsck finished at Thu Nov  1 07:18:43 2007
###########

Cheers,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--RUh7Gb6wQL2PrpWP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHKcXWND0rFCN2b1sRAtZWAJ4lSVouW5z6tQjES6OLEEMSD0d45QCeKdoP
ugDA6we0W78OMHY99vWvCE8=
=lAqt
-----END PGP SIGNATURE-----

--RUh7Gb6wQL2PrpWP--

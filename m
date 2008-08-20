Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYHTRKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYHTRKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 13:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbYHTRJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 13:09:54 -0400
Received: from rrcs-70-62-214-221.central.biz.rr.com ([70.62.214.221]:56127
	"EHLO tophat.atxconsulting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750801AbYHTRJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 13:09:53 -0400
X-Greylist: delayed 781 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Aug 2008 13:09:53 EDT
Date: Wed, 20 Aug 2008 13:09:51 -0400
From: Timothy J Fontaine <tjfontaine@atxconsulting.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: r8169 MTU greater than 1500 causes corruption for other controllers
Message-ID: <20080820170951.GA1771@tophat.atxconsulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
X-PGP-Key: http://atxconsulting.com/MyPublicKey?action=AttachFile&do=get&tar
	get=tjfontaine.atxconsulting.asc
X-PGP-Key-Fingerprint: 7937 DFD2 AB06 298B 2293  C318 7D33 FF9D 0246 406D
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Setting the MTU to greater than 1500 causes the host system to run out
of SW-IOMMU space for the transfer. This results in corruption for other
controllers like my AAR-2410SA or IDE controller.

Host system:
 ASUS P5M2 w/ Intel Core 2 Duo 6320
 Linux version 2.6.24-19-server (buildd@king) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #1 SMP Fri Jul 11 21:50:43 UTC 2008
 r8169 chipset pci card

Connected via Cross-Over cable to:
 SuperMicro 6014Hi
 Onboard Intel 82546GB e1000 chipset
 Running latest VMware ESXi or Vanilla 2.6.26

Initially I presumed the issue was with my aacraid because of the
trace[1], so I built a vanilla 2.6.26.2 and hit the same bug. I have
another system running 2.6.20 and the same card working so I tried
2.6.22 and had no problem. However, 2.6.23 failed. I sifted through the
ChangeLog for 2.6.23 and narrowed the field to some potential problem
commits regarding aacraid. I then proceeded to do a git bisect and found
commit b449655ff52ff8a29c66c5fc3fc03617e61182ee[2] which had nothing to
do with aacraid. Instead, the commit deals with large packets so I reset
the MTU to 1500 and retried on 2.6.24 and found that there was no
corruption, I then proceeded to try with various different size MTU only
to find that an MTU greater than 1500 triggers the corruption.

After initially encountering the bug with VMware ESXi I booted into a
vanilla 2.6.26 live cd and mounted an nfs share from the host with the
r8169 card and used dd_rescue to generate large files and transfers on
the host to expose the bug.

[1] http://tophat.atxconsulting.com/~tjfontaine/r8169_bug_report/oops_trace.txt
[2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=b449655ff52ff8a29c66c5fc3fc03617e61182ee

Below you'll find a list of files referenced from REPORTING-BUGS that
are meant to be helpful, including the lspci and module information,
they can all be reached from the toplevel directory index

http://tophat.atxconsulting.com/~tjfontaine/r8169_bug_report/

http://tophat.atxconsulting.com/~tjfontaine/r8169_bug_report/cpuinfo
http://tophat.atxconsulting.com/~tjfontaine/r8169_bug_report/iomem
http://tophat.atxconsulting.com/~tjfontaine/r8169_bug_report/ioports
http://tophat.atxconsulting.com/~tjfontaine/r8169_bug_report/lspci
http://tophat.atxconsulting.com/~tjfontaine/r8169_bug_report/modules
http://tophat.atxconsulting.com/~tjfontaine/r8169_bug_report/oops_trace.txt
http://tophat.atxconsulting.com/~tjfontaine/r8169_bug_report/scsi
http://tophat.atxconsulting.com/~tjfontaine/r8169_bug_report/ver_linux

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkisT98ACgkQfTP/nQJGQG2QbgCgriQuZdr/hjcamxatxVmdH31q
79gAn20/kObzdFm9OVTS4BTG4XuaThtd
=8gbB
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--

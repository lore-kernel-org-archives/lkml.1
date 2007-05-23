Return-Path: <linux-kernel-owner+w=401wt.eu-S1757749AbXEWRj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757749AbXEWRj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 13:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762088AbXEWRjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 13:39:47 -0400
Received: from cg-p07-fb.rzone.de ([81.169.146.215]:9207 "EHLO
	cg-p07-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756433AbXEWRjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 13:39:46 -0400
X-Greylist: delayed 1959 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 May 2007 13:39:46 EDT
Date: Wed, 23 May 2007 19:07:03 +0200
From: Nico Golde <nico@ngolde.de>
To: linux-kernel@vger.kernel.org
Subject: maximum count of thermal zones and fans in acpi?
Message-ID: <20070523170702.GA9169@ngolde.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Content-Disposition: inline
X-Mailer: netcat 1.10
X-GPG: 0x73647cff
X-RZG-AUTH: hvKiKtSHbeE0ghP2VIXOfz9FbKPIjAFDNRMtknfPuvqS60u3mcM1eRXO+wCdbA==
X-RZG-CLASS-ID: mo00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
I am currently implementing a general purpose shared library=20
for acpi focused on all the tools giving acpi information=20
like battery, thermal zones, fans, etc.

Since I was not able to find anything about it in the acpi=20
specs[0] (of course I didn't read every single page though)
and with a quick look into the kernel sources I wondered if=20
there is a maximum count for thermal zones and fans in the=20
acpi implementation of the kernel.

Every acpi module just calls proc_mkdir for example:
       acpi_device_dir(device) =3D proc_mkdir(acpi_device_bid(device),
                                            acpi_thermal_dir);

struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode,
                struct proc_dir_entry *parent)
{
        struct proc_dir_entry *ent;

        ent =3D proc_create(&parent, name, S_IFDIR | mode, 2);
        if (ent) {
                ent->proc_fops =3D &proc_dir_operations;
                ent->proc_iops =3D &proc_dir_inode_operations;

                if (proc_register(parent, ent) < 0) {
                        kfree(ent);
                        ent =3D NULL;
                }
        }
        return ent;
}

struct proc_dir_entry *proc_mkdir(const char *name,
                struct proc_dir_entry *parent)
{
        return proc_mkdir_mode(name, S_IRUGO | S_IXUGO, parent);
}


So is there no check for any max item count here?

I ask because I need to decide whether I want to allocate space for every
acpi object or to use a fixed size array for them depending on the maximum
item (where item is one device) count.

[0]: http://www.acpi.info/spec.htm

Kind regards
Nico
P.S. Please Cc me I am not subscribed

--=20
Nico Golde - http://ngolde.de - nion@jabber.ccc.de - GPG: 0x73647CFF
For security reasons, all text in this mail is double-rot13 encrypted.

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGVHS2HYflSXNkfP8RAptKAKCKBrnDsQL+XhV4Cc6XGSuHRi7+OwCghVRZ
nXP1/hrLRO/dP2fGk1tju7E=
=+cEW
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--

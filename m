Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbXHaPFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbXHaPFj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 11:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755345AbXHaPFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 11:05:18 -0400
Received: from orca.ele.uri.edu ([131.128.51.63]:41778 "EHLO orca.ele.uri.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758862AbXHaPE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 11:04:59 -0400
Date: Fri, 31 Aug 2007 11:05:44 -0400
From: Will Simoneau <simoneau@ele.uri.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: new x86 setup code hangs on Dell Inspiron 5150
Message-ID: <20070831150326.GA6003@ele.uri.edu>
References: <20070831015620.GA6259@ele.uri.edu> <46D7AAF7.1030105@zytor.com> <46D7B817.3060304@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <46D7B817.3060304@zytor.com>
User-Agent: Mutt/1.5.16 [Linux 2.6.21.1-grsec-b0rg i686]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 23:41 Thu 30 Aug     , H. Peter Anvin wrote:
> H. Peter Anvin wrote:
>> Will Simoneau wrote:
>>> While trying to put together a new kernel for my laptop (Dell I5150, as
>>> in subject) I found that recent kernels just don't boot. Right after
>>> grub loads the kernel, before the "Uncompressing Linux" message is
>>> shown, it hangs. The BIOS appears to still be alive (ctrl-alt-del works,
>>> keyboard lock LEDs respond). It seems to be caused by the new x86 setup
>>> code.
>>>
>>> My kernel is Linus' git as of a1c582d0720f2eff61043e90711767decf37b917.
>>> I bisected and confirmed that 4fd06960f120e02e9abc802a09f9511c400042a5
>>> triggers a non-functioning boot.
>>>
>>> This system has Dell BIOS rev A38 and a P4 3.2 w/HT.
>>>
>>> What should I do next to debug this problem?
>> Can you put in some printf's in the code and see how far it gets?
>
> Specifically, the places to add printf's are to main() in main.c and=20
> go_to_protected_mode() in pm.c.
>
> 	-hpa

It dies in vesa_probe() right after calling int10 with ax=3D4f01 and
checking the return status, which was 0x004f (success). This happens on
the third iteration of the loop; the first two modes it finds are
framebuffer modes. This would be just after line 72 in video-vesa.c .

I have CONFIG_VIDEO_VESA=3Dy and CONFIG_FB=3Dy, but am not passing the
kernel options that would use vesafb as the console.

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iD8DBQFG2C5HLYBaX8VDLLURAnZ7AJ4gApNtkuBxpuSRYen+KuAqUC4QowCeLz+B
G9JC03yfGO2oPCUXMbnLLPM=
=uQj2
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--

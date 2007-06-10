Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbXFJNmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbXFJNmS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 09:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbXFJNmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 09:42:08 -0400
Received: from master.altlinux.org ([62.118.250.235]:4563 "EHLO
	master.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbXFJNmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 09:42:07 -0400
X-Greylist: delayed 1694 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Jun 2007 09:42:06 EDT
Date: Sun, 10 Jun 2007 17:13:21 +0400
From: Sergey Vlasov <vsu@altlinux.ru>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Jon Masters <jonathan@jonmasters.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Kyle McMartin <kyle@canonical.com>,
       Christoph Pleger <Christoph.Pleger@cs.uni-dortmund.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Size of kernel modules
Message-Id: <20070610171321.1fbf37d5.vsu@altlinux.ru>
In-Reply-To: <Pine.LNX.4.64.0706091558460.14652@fbirervta.pbzchgretzou.qr>
References: <20070606170534.67b5dea9.Christoph.Pleger@cs.uni-dortmund.de>
	<20070608034421.GM26717@fattire.cabal.ca>
	<Pine.LNX.4.64.0706080838210.17480@localhost.localdomain>
	<Pine.LNX.4.64.0706090954310.4353@fbirervta.pbzchgretzou.qr>
	<1181390911.3306.22.camel@jcmlaptop>
	<Pine.LNX.4.64.0706091558460.14652@fbirervta.pbzchgretzou.qr>
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.10.6; x86_64-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__10_Jun_2007_17_13_21_+0400_gvRunncOIymlHXw9"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__10_Jun_2007_17_13_21_+0400_gvRunncOIymlHXw9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Sat, 9 Jun 2007 15:59:55 +0200 (CEST) Jan Engelhardt wrote:

> On Jun 9 2007 08:08, Jon Masters wrote:
> >
> >So I missed half of this conversation - you're saying that on a
> >CONFIG_DEBUG_KERNEL, you have such large .ko module files that depmod
> >segfaults? Can I get a core dump or any further information? :-)
>
> Just make sure your /lib/modules/<kernel> is like 300 megabytes or
> even more. Then depmod will clog up quite a lot memory already.
> (Taking a 256 mb ram machine for example, no swap or just very
> little.)

I have noticed such problems before - the depmod code just loads whole
module files into memory.  The situation is especially bad when
module-init-tools is configured with --enable-zlib - in this case memory
for all module files is allocated with malloc().  (Without --enable-zlib
depmod just mmaps all module files, which at least does not eat swap,
and probably does not bring unused pages into memory.)

I have made some patches to module-init-tools - unfortunately, they
probably don't apply to the current version (they were based on
v3.3-pre4):

git://git.altlinux.org/people/vsu/packages/module-init-tools.git
(release-module-data branch)

http://git.altlinux.org/people/vsu/packages/?p=module-init-tools.git;a=shortlog;h=release-module-data

--Signature=_Sun__10_Jun_2007_17_13_21_+0400_gvRunncOIymlHXw9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.1 (GNU/Linux)

iD8DBQFGa/jxW82GfkQfsqIRAhx8AJoCC7NQT+Oltxwj/eRBt0UJ3io66gCdGO47
1gUGBGXdZ1lVUC2euk+UBu8=
=FbVQ
-----END PGP SIGNATURE-----

--Signature=_Sun__10_Jun_2007_17_13_21_+0400_gvRunncOIymlHXw9--

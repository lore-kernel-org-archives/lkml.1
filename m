Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZA3G3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZA3G3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 01:29:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbZA3G3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 01:29:34 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:39077 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbZA3G3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 01:29:33 -0500
Date: Thu, 29 Jan 2009 23:29:31 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org,
       =?ISO-8859-15?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH D 01/11] OMAP: Add clk_get_parent() for OMAP2/3
In-Reply-To: <20090129110043.GE12627@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0901292327090.26985@utopia.booyaka.com>
References: <20090128191638.16688.33452.stgit@localhost.localdomain> <20090128191807.16688.91255.stgit@localhost.localdomain> <20090129110043.GE12627@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="155748971-856422142-1233296971=:26985"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--155748971-856422142-1233296971=:26985
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Thu, 29 Jan 2009, Russell King - ARM Linux wrote:

> On Wed, Jan 28, 2009 at 12:18:16PM -0700, Paul Walmsley wrote:
> > From: Mans Rullgard <mans@mansr.com>
> >=20
> > This makes clk_get_parent() work on OMAP2/3.
>=20
> This is clearly something that the generic code should be doing.
> It's not something specific to OMAP2/3.  Please move it to
> arch/arm/plat-omap/clock.c

Done; revised patch below.

- Paul


From: Mans Rullgard <mans@mansr.com>
Date: Thu Jan 29 23:26:35 2009 -0700

    OMAP: Add clk_get_parent() for OMAP1/2/3
   =20
    This makes clk_get_parent() work on OMAP.

    linux-omap source commit is efd65273726b12e42c7225bd1703e5252bdb46c0.
   =20
    Signed-off-by: M=E5ns Rullg=E5rd <mans@mansr.com>
    Signed-off-by: Tony Lindgren <tony@atomide.com>
    [paul@pwsan.com: per rmk, made this function available on all OMAPs
     and fixated its implementation]
    Signed-off-by: Paul Walmsley <paul@pwsan.com>

diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index be6aab9..eb59874 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -210,18 +210,7 @@ EXPORT_SYMBOL(clk_set_parent);
=20
 struct clk *clk_get_parent(struct clk *clk)
 {
-=09unsigned long flags;
-=09struct clk * ret =3D NULL;
-
-=09if (clk =3D=3D NULL || IS_ERR(clk))
-=09=09return ret;
-
-=09spin_lock_irqsave(&clockfw_lock, flags);
-=09if (arch_clock->clk_get_parent)
-=09=09ret =3D arch_clock->clk_get_parent(clk);
-=09spin_unlock_irqrestore(&clockfw_lock, flags);
-
-=09return ret;
+=09return clk->parent;
 }
 EXPORT_SYMBOL(clk_get_parent);
=20
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/i=
nclude/mach/clock.h
index f6adf39..47c9a11 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -104,7 +104,6 @@ struct clk_functions {
 =09long=09=09(*clk_round_rate)(struct clk *clk, unsigned long rate);
 =09int=09=09(*clk_set_rate)(struct clk *clk, unsigned long rate);
 =09int=09=09(*clk_set_parent)(struct clk *clk, struct clk *parent);
-=09struct clk *=09(*clk_get_parent)(struct clk *clk);
 =09void=09=09(*clk_allow_idle)(struct clk *clk);
 =09void=09=09(*clk_deny_idle)(struct clk *clk);
 =09void=09=09(*clk_disable_unused)(struct clk *clk);
--155748971-856422142-1233296971=:26985--

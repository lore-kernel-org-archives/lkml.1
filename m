Return-Path: <linux-kernel-owner+w=401wt.eu-S1761602AbYD2Wsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761602AbYD2Wsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYD2Wsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:48:46 -0400
Received: from ns3.system-techniques.com ([204.91.156.41]:58292 "EHLO
	ns3.baby-dragons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbYD2Wsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:48:45 -0400
X-Greylist: delayed 1175 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Apr 2008 18:48:45 EDT
Date: Tue, 29 Apr 2008 14:29:04 -0800 (AKDT)
From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
To: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>
cc: Linux Kernel Maillist <linux-kernel@vger.kernel.org>
Subject: Re: HP server and atto driver from hell
In-Reply-To: <20080429201727.GV8066@charite.de>
Message-ID: <Pine.LNX.4.64.0804291425260.23575@filesrv1.baby-dragons.com>
References: <20080429201727.GV8066@charite.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="566704117-2006034049-1209508144=:23575"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.8 (ns3.baby-dragons.com [204.91.156.41]); Tue, 29 Apr 2008 22:29:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--566704117-2006034049-1209508144=:23575
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

 =09Hello Ralf ,  Fyi ,  the fusion/mpt driver supports some of the ATTO=20
devices ,  if your lspci -v for the ATTO controllers looks simular to this =
one=20
it may just work with the fusion drivers .
 =09Hth ,  JimL

# lspci -v -s 0d:04.0
0d:04.0 SCSI storage controller: Atto Technology Ultra320 SCSI Host Adapter=
 (rev 08)
         Subsystem: Atto Technology Unknown device 8027
         Flags: bus master, 66MHz, medium devsel, latency 128, IRQ 16
         I/O ports at 5000 [size=3D256]
         Memory at d8640000 (64-bit, non-prefetchable) [size=3D256K]
         Memory at d8600000 (64-bit, non-prefetchable) [size=3D256K]
         Capabilities: [50] Power Management version 2
         Capabilities: [58] Message Signalled Interrupts: 64bit+ Queue=3D0/=
0 Enable-
         Capabilities: [68] PCI-X non-bridge device



On Tue, 29 Apr 2008, Ralf Hildebrandt wrote:
> We thought HP would be a smart choice when it comes to Linux,..
> Until now, because now we have to use a PCI Express SCSI card that
> comes with a proprietary driver that won't even compile.
>
> When I untar the lnx_drv_epciu320_107.tar.gz and try to compile the
> glue between the binary blob and the kernel, I get:
>
> c# make -k modules
> Architecture is i386 (x86_regparm)
> make[1]: Entering directory /usr/src/linux-2.6.25'
>  CC [M]  /usr/src/lnx_drv_epciu320_107/src/atto_cfg.o
>  /usr/src/lnx_drv_epciu320_107/src/atto_cfg.c: In function =E2=80=98attoc=
fg_read_version=E2=80=99: /usr/src/lnx_drv_epciu320_107/src/atto_cfg.c:258:=
 error: =E2=80=98struct device_driver=E2=80=99 has no member named =E2=80=
=98kobj=E2=80=99
> make[2]: *** [/usr/src/lnx_drv_epciu320_107/src/atto_cfg.o] Error 1
>  CC [M]  /usr/src/lnx_drv_epciu320_107/src/oswrap.o
>  /usr/src/lnx_drv_epciu320_107/src/oswrap.c: In function =E2=80=98express=
2_attocfg_register=E2=80=99: /usr/src/lnx_drv_epciu320_107/src/oswrap.c:908=
: error: =E2=80=98struct device_driver=E2=80=99 has no member named =E2=80=
=98kobj=E2=80=99
> make[2]: *** [/usr/src/lnx_drv_epciu320_107/src/oswrap.o] Error 1
> make[2]: Target __build' not remade because of errors.
> make[1]: *** [_module_/usr/src/lnx_drv_epciu320_107/src] Error 2
> make[1]: Target modules' not remade because of errors.
> make[1]: Leaving directory /usr/src/linux-2.6.25'
> make: *** [modules] Error 2
>
> in atto_cfg.c:
>
>   258          if (this_drvr->kobj =3D=3D &driver->kobj)
>   259          {
>   260              if (this_drvr->read_version)
>   261                  return (*this_drvr->read_version) (driver, buffer)=
;
>   262              else
>   263                  return 0;
>   264          }
>
> and in oswrap.o:
>
>   905                  return NULL;
>   906      }
>   907
>   908      return &atto_pci_driver.driver.kobj;
>   909  }
>   910
>
>
>

--=20
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
--566704117-2006034049-1209508144=:23575--

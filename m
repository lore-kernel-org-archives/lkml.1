Return-Path: <linux-kernel-owner+w=401wt.eu-S1752094Ab0AVFRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0AVFRk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 00:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751343Ab0AVFRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 00:17:39 -0500
Received: from mail-px0-f182.google.com ([209.85.216.182]:44933 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab0AVFRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 00:17:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=OGxaJCguxLO2peMWBTBt2hSRvTnSQm3ADjTBjbz+iq4nkACKblWsyXSX7fZFq+itie
         x6lljdCc76xGm6e7qe+Kj0GYvVEDKfb/sNdUuAnj8pJmWuijQoO1b2N/jax/o877mv47
         ged39+00oawMZVymnPHaEil6LmUiLsurx/Ex4=
MIME-Version: 1.0
Date: Fri, 22 Jan 2010 10:47:38 +0530
Message-ID: <aacba7e1001212117g7b367ef0x3cf078d427b184cd@mail.gmail.com>
Subject: libATA blacklist Crucial/Micron SSD M225 models due to NCQ errors?
From: Vishal Rao <vishalrao@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

(please CC me in any replies as I'm not subscribed to the list).

I wonder if it's appropriate to blacklist the Crucial.com M225 family
of solid state disks?

Could the following line be added to drivers/ata/libata-core.c around
line 4276 (2.6.33-rc4) right alongside the
"OCZ CORE_SSD" blacklist entry for ATA_HORKAGE_NONCQ ?

[code]
{ "CRUCIAL_CT128M225", NULL, ATA_HORKAGE_NONCQ },
[/code]

I'm assuming the first string param matches with the ID I see in the
logs, the second param is for firmware ID and NULL means it will match
all?
This is just for the 128 GB model and there are also 64 and 256 GB
models - I hope Crucial can revise their IDs to be variant agnostic
and just
return something like OCZ does like say "CRUCIAL_M225".

I have a 128 GB model CT128M225 and am running kernel 2.6.32 series
that comes with Ubuntu Linux 10.04 Alpha 2.

There are regular kernel dmesg error/warning messages related to
"ata1" (my SSD) including a "failed command READ FPDMA QUEUED".
See http://pastebin.ubuntu.com/347122/

After some STFW-ing, I realised it's related to NCQ which the disk
firmware (v1916) probably doesn't support/implement well.

Solution/workaround for me is to add " libata.force=noncq " to the
kernel boot options so I am not too worried although I though if this
goes into the kernel (and backported to .32 series which a lot of
vendors plan to use or long term distro support) it would
save a lot of headache for regular users who might dump Linux distros
for other systems.

(please CC me in any replies as I'm not subscribed to the list).

Thanks,
Vishal

--
"Thou shalt not follow the null pointer for at its end madness and chaos lie."

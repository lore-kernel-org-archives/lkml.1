Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbZJNGyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbZJNGyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 02:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755591AbZJNGyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 02:54:39 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:46508 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbZJNGyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 02:54:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=juMRtkezXzmyXnE+Be1N7uVv0BuLkRnP98UzB0NuOqUq32+WkYv+y0HttFnKdWGha1
         Yr13gUJNBnTLAzwaZlBHxGUpsTMPHooaHzOI6ayiViK7h/RifSSSXI0bfVn6FXpzhCzo
         htxSRXSwgzukJoCzNRGMYUjagom92LPAYUv6Y=
MIME-Version: 1.0
In-Reply-To: <20091013192040.22336.84876.stgit@bob.kio>
References: <20091013192040.22336.84876.stgit@bob.kio>
Date: Tue, 13 Oct 2009 23:47:33 -0700
Message-ID: <86802c440910132347x1913d2a1taf35f385af50e17c@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] PCI, PNP: print resources consistently
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Joe Perches <joe@perches.com>, Len Brown <lenb@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 12:21 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> These enhance %pR so we can print resource types and flags more easily.
> This doesn't really add anything (other than a couple new messages
> about host bridge apertures), but hopefully it will make things more
> consistent and a bit easier to debug.  Sample change (with "pci=use_crs"):
>
>    -pci 0000:00:03.0: reg 10 32bit mmio: [0xf6000000-0xf6ffffff]
>    -pci 0000:00:03.0: reg 14 io port: [0x2400-0x24ff]
>    -pci 0000:00:03.0: reg 18 32bit mmio: [0xf5ff0000-0xf5ff0fff]
>    -pci 0000:00:03.0: reg 30 32bit mmio pref: [0x000000-0x01ffff]
>    +pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cff]
>    +pci_root PNP0A03:00: host bridge window [io  0x0000-0x2cfe]
>    +pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03bb]
>    +pci_root PNP0A03:00: host bridge window [io  0x03c0-0x03df]
>    +pci_root PNP0A03:00: host bridge window [mem 0xf5d00000-0xf6ffffff]
>    +pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
>    +pci 0000:00:03.0: reg 10: [mem 0xf6000000-0xf6ffffff]
>    +pci 0000:00:03.0: reg 14: [io  0x2400-0x24ff]
>    +pci 0000:00:03.0: reg 18: [mem 0xf5ff0000-0xf5ff0fff]
>    +pci 0000:00:03.0: reg 30: [mem 0x00000000-0x0001ffff pref]

can you keep "io port" and "mmio" ?
so we can use
grep "io port" dmesg.txt or grep "mmio" dmesg.txt

also put "io" and "mmio" "pref' in the [  ], looks strange.
[0xf5ff0000-0xf5ff0fff] is correct range expression.

YH

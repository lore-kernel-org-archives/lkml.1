Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXCYSNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXCYSNz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 14:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932318AbXCYSNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 14:13:54 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:64898 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbXCYSNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 14:13:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CMPzumXwKg08FB61T/kS6RtUmBA/A0u9XnTyduV6Q45X6pSVwxLlJ+25B6p+cnGgo2Hxyc5/a7IhPKA23d+bhVFnQFb6zljNN2ySF4rrcEgOdaf3T9CoSOYUA/vlFUr+fzX1LHtoNHTYJLU21I30f2Ag035cXbeeVF+0VEBCrFs=
Message-ID: <64bb37e0703251113v4d4e6acdg92faf6722e9bc2df@mail.gmail.com>
Date: Sun, 25 Mar 2007 19:13:50 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: drivers/pci/probe.c patch in 2.6.20.4 causes 'cannot adjust BAR0 (not I/O)' on NVidia MCP51
Cc: "Kevin P. Fleming" <lkml@kpfleming.us>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <4606A6B0.4010601@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <460693EB.9080203@kpfleming.us> <4606A6B0.4010601@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/25/07, Gabriel C <nix.or.die@googlemail.com> wrote:
> Kevin P. Fleming wrote:
> > I just upgraded from 2.6.20.2 to 2.6.20.4 on my Compaq V6000 laptop,
> > which has an NVidia core chipset. It has the MCP51 and uses it for PATA
> > and SATA.
> >
> > Booting the 2.6.20.4 kernel causes two messages (and a kernel lockup)
> > like this:
> >
> > 0000:00:0d.0: cannot adjust BAR0 (not I/O)
> > 0000:00:0d.0: cannot adjust BAR1 (not I/O)
> >
> [   18.754623] Enabling SiS 96x SMBus.
> [   18.754812] 0000:00:02.5: cannot adjust BAR0 (not I/O)
> [   18.754816] 0000:00:02.5: cannot adjust BAR1 (not I/O)
> [   18.754819] 0000:00:02.5: cannot adjust BAR2 (not I/O)
> [   18.754822] 0000:00:02.5: cannot adjust BAR3 (not I/O)

I am seeing this also, but on a MCP55

Mar 25 18:56:37 treogen [   50.828369] 0000:00:04.0: cannot adjust
BAR0 (not I/O)
Mar 25 18:56:37 treogen [   50.843736] 0000:00:04.0: cannot adjust
BAR1 (not I/O)
Mar 25 18:56:37 treogen [   50.859120] 0000:00:04.0: cannot adjust
BAR2 (not I/O)
Mar 25 18:56:37 treogen [   50.874504] 0000:00:04.0: cannot adjust
BAR3 (not I/O)


00:04.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1) (prog-if
8a [Master SecP PriP])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81f0
        Flags: bus master, 66MHz, fast devsel, latency 0
        [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
[disabled] [size=8]
        [virtual] Memory at 000003f0 (type 3, non-prefetchable)
[disabled] [size=1]
        [virtual] Memory at 00000170 (32-bit, non-prefetchable)
[disabled] [size=8]
        [virtual] Memory at 00000370 (type 3, non-prefetchable)
[disabled] [size=1]
        I/O ports at ffa0 [size=16]
        Capabilities: [44] Power Management version 2
00: de 10 6e 03 05 00 b0 00 a1 8a 01 01 00 00 00 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: a1 ff 00 00 00 00 00 00 00 00 00 00 43 10 f0 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 00 00 03 01

I am not using the IDE interface so I can't tell if it is working or
not, but the boot does not hang.

Torsten

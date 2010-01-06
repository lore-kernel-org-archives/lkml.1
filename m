Return-Path: <linux-kernel-owner+w=401wt.eu-S932742Ab0AFUS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932742Ab0AFUS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:18:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932580Ab0AFUS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:18:28 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:7974 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab0AFUS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:18:27 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alex Brooks <a.brooks@marathon-robotics.com>
Subject: Re: BAR 0: can't allocate resource
Date: Wed, 6 Jan 2010 13:19:54 -0700
User-Agent: KMail/1.12.2 (Linux/2.6.31-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201001061305.31635.a.brooks@marathon-robotics.com> <201001061316.21744.a.brooks@marathon-robotics.com>
In-Reply-To: <201001061316.21744.a.brooks@marathon-robotics.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001061319.54436.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010 07:16:21 pm Alex Brooks wrote:
> > I don't see any indication that this is a software problem (I know
> > nothing about PC/104, so let me know if you disagree, and why).
> 
> I don't have a smoking gun that points at software, it was just my guess
>  based on:
>  a) all the pieces of hardware work in certain combinations
>  b) there's a nasty-looking error message in dmesg

You mentioned two messages.  Here's the first:
  PCI: BIOS Bug: MCFG area at e0000000 is not reserved in ACPI motherboard resources
  PCI: Not using MMCONFIG.

and the second:
  PCI: Cannot allocate resource region 0 of device 0000:01:04.0
  PCI: Error while updating region 0000:01:04.0/0 (feb00002 != 00000000)

The "Error while updating region" message is because we wrote something
to a BAR, read it back, and they didn't match.  I suppose this could be
some kind of config space problem related to the fact that we're not
using MMCONFIG.

Can you try removing the MCFG reservation check, so we do try to use
MMCONFIG?  If you do this on a current kernel, we'll also get a little
more debug output about the subsequent resource allocation failure.

Bjorn

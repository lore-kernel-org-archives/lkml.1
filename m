Return-Path: <linux-kernel-owner+w=401wt.eu-S1763042AbZAORyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763042AbZAORyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759008AbZAORyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:54:05 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:59699 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758591AbZAORyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:54:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Ira Snyder <iws@ovro.caltech.edu>
Subject: Re: [PATCH RFC v5] net: add PCINet driver
Date: Thu, 15 Jan 2009 18:53:51 +0100
User-Agent: KMail/1.9.9
Cc: Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       shemminger@vyatta.com, netdev@vger.kernel.org
References: <20090107195052.GA24981@ovro.caltech.edu> <200901151358.34250.arnd@arndb.de> <20090115165359.GA2230@ovro.caltech.edu>
In-Reply-To: <20090115165359.GA2230@ovro.caltech.edu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200901151853.52202.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+2quA1+agx/kyupFpc4O4E5h7Q5jillcStMBd
 N5nOc+dnUNHFcXior8U6MDsPH83GVWypi7hTksLW0yR/g2Hnsz
 qMjRKmQVi0UERll73K+Jw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 January 2009, Ira Snyder wrote:
> 
> These are PCI boards, not PCIe. The host computers are all Pentium3-M
> systems. I tried enabling MSI on the Freescale boards in the driver, by
> calling pci_enable_msi() during probe(), and it failed. 

That doesn't really mean anything, just that the PCI endpoint doesn't
announce its capability to do MSI in the config space, or that it
does not have an interrupt line. Since you basically implement the
device on the FSL board, you should also be able to define the interrupt
capabilities by writing to the config space.

Do you know what kind of chipset the host uses? It should be fairly
simple to find out whether or not it can do MSI.

	Arnd <><

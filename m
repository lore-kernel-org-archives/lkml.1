Return-Path: <linux-kernel-owner+w=401wt.eu-S1756966AbZAIXd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756966AbZAIXd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 18:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZAIXds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 18:33:48 -0500
Received: from outbound-mail-16.bluehost.com ([69.89.20.231]:55836 "HELO
	outbound-mail-16.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751661AbZAIXdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 18:33:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=jwP0fJHl9faIJRqbXyyPrN1phmPcPXYPBGZ7AlCWRA8ZRyve7rX2AkiQhDRF398IXIOurZ4QvjNMxrYUJuzgGFGZ/TOEIJZ1YNhmepPM1imw83yeuSdTsA8A5Mxdh2/h;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 5/8] PCI PCIe portdrv: Fix allocation of interrupts
Date: Fri, 9 Jan 2009 15:33:43 -0800
User-Agent: KMail/1.9.10
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Linux PCI <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200901042346.42723.rjw@sisk.pl> <200901081753.01637.rjw@sisk.pl> <200901082145.39429.rjw@sisk.pl>
In-Reply-To: <200901082145.39429.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901091533.44460.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 8, 2009 12:45 pm Rafael J. Wysocki wrote:
> On Thursday 08 January 2009, Rafael J. Wysocki wrote:
> > On Thursday 08 January 2009, Kenji Kaneshige wrote:
> > > Rafael J. Wysocki wrote:
> > > > On Thursday 08 January 2009, Kenji Kaneshige wrote:
> > > >> Rafael J. Wysocki wrote:
> > > >>> From: Rafael J. Wysocki <rjw@sisk.pl>
> > > >>>
> > > >>> If MSI-X interrupt mode is used by the PCI Express port driver, too
> > > >>> many vectors are allocated and it is not ensured that the right
> > > >>> vectors will be used for various services.  Namely, the PCI Express
> > > >>> specification states that both PCI Express native PME and PCI
> > > >>> Express hotplug will always use the same MSI or MSI-X message for
> > > >>> signalling interrupts, which implies that the same vector will be
> > > >>> used by both of them.  Also, the VC service does not use interrupts
> > > >>> at all. Moreover, is not clear which of the vectors allocated by
> > > >>> pci_enable_msix() will be used for PME and hotplug and which of
> > > >>> them will be used for AER if all of these services are configured.
> > > >>>
> > > >>> For these reasons, rework the allocation of interrupts for PCI
> > > >>> Express ports so that at most two vectors are allocated and ensure
> > > >>> that the right vector will be used for the right purpose.
>
> Appended is a cleaned-up version of the patch that also contains comments
> with references to the appropriate sections of the PCI Express spec.

We'll need testing here in any case; I'll have to re-read the specs carefully 
to see if we can really rely on the vector numbers you have here (at first 
glance Kenji-san's approach seems more robust).

-- 
Jesse Barnes, Intel Open Source Technology Center

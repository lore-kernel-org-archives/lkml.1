Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbZAFUVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbZAFUVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbZAFUVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:21:21 -0500
Received: from outbound-mail-309.bluehost.com ([67.222.54.2]:60825 "HELO
	outbound-mail-309.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753588AbZAFUVU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:21:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=c0jnZjEllDT6lCv/AQ2TYLLxE4rTRjzLjid4JeqhOOaDGLwgApOV+YB7HonJe3WceosRkXmR3FnNIkTscRJxh8rTr27TIsqYI2Yd+4dG+zSjyHqzQPWRwIexxd/Dp9TP;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH 2.6.28 1/3] PCI-quirks: Unhide MCH5/6 memory controller configuration device
Date: Tue, 6 Jan 2009 12:21:18 -0800
User-Agent: KMail/1.9.10
Cc: =?iso-8859-2?q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       bluesmoke-devel@lists.sourceforge.net
References: <20081223215030.GA32525@rere.qmqm.pl> <20090105203006.GC26115@rere.qmqm.pl> <200901061202.04321.bjorn.helgaas@hp.com>
In-Reply-To: <200901061202.04321.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901061221.18512.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 6, 2009 11:02 am Bjorn Helgaas wrote:
> On Monday 05 January 2009 01:30:06 pm Micha³ Miros³aw wrote:
> > Some BIOSes hide 'overflow' device (dev #6) for i82875P/PE chipsets.
> > The same happens for i82865P/PE. Add a quirk to enable this device.
> > This allows i82875 EDAC driver to bind to chipset's dev #6 and not
> > dev #0 as the latter is used by AGP driver.
> >
> > After testing this patch for couple of days on my laptop (i82856P)
> > it looks like something is resetting device 0 (MCH) config register
> > 0xF4 to zero and effectively disabling the device again. The delay
> > looks random to me.
>
> The BIOS left the device hidden.  When you enable it with the quirk,
> the fact that it mysteriously gets disabled later seems like a pretty
> clear indication that something else we don't know about is using the
> device.  Since there's no synchronization between the "something else"
> and the i82875p_edac.c driver, it seems like you're introducing the
> possibility for problems.
>
> I don't know anything about the EDAC driver.  Is the value it provides
> really worth the possible problems with this approach?  Maybe it is,
> but I don't want to be the one to debug a random interaction that
> causes a problem.

Yeah, there's some uncertainty there for sure so I've dropped the patch.  If 
it really provides a compelling feature we can always add it again with a 
config option or runtime option to enable it.

-- 
Jesse Barnes, Intel Open Source Technology Center

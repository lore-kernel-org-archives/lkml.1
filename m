Return-Path: <linux-kernel-owner+w=401wt.eu-S1754409AbYCRAAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754409AbYCRAAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 20:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYCRAA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 20:00:29 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:42639 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751124AbYCRAA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 20:00:28 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=c9IOskyCmnYVdfrZlXmO6HzbR+AlJykFh4CnWbXJ6kEBCs6vpDCQyweTqArMThB8QpeSjn0JdokIrjdMiPEgu7uMjlORSIm/+palxkrDi9RFgCTMrxlHpbs0UyibgmwjHtsHPxWOtHyaXH8W1a8sldQw68zGAKm2zvQb/YFhba4=  ;
X-YMail-OSG: GAen8L4VM1lUrOKMjkiEkCcBA3DO1OOuqt9c1pk1Y_7zbQ43QVMfe8i0C6YVsTJbKYbmUgPrtQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Rene Herman <rene.herman@keyaccess.nl>
Subject: Re: ehci-hcd affects hda speed
Date: Mon, 17 Mar 2008 16:00:25 -0800
User-Agent: KMail/1.9.6
Cc: "Lev A. Melnikovsky" <melnikovsky@mail.ru>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <200803171400.40045.david-b@pacbell.net> <47DEFD85.1050706@keyaccess.nl>
In-Reply-To: <47DEFD85.1050706@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200803171700.26274.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Rene Herman wrote:
> +       case PCI_VENDOR_ID_VIA:
> +               if (pdev->device == 0x3104 && pdev->revision >= 0x60) {

Unless you have specific docs from VIA saying that this register
isn't revision-specific (at least in the sense that all revisions
after 0x60 define that bit in that way), this should probably be a
switch on pdev->revision and just include the known-safe revisions.

At one point I had a table mapping those revision codes to
specific VIA chips.  Too bad I didn't keep it.  ISTR that the
VT6212 has a newer revision code than the vt8235 southbridge,
and probably not as new as the vt8237 one...

But otherwise, yes -- that's the kind of patch I'd sign off on
after making this comment a bit more informative about how
that 1 usec sleep time creates an amount of PCI bus hogging.


> +                       u8 tmp;
> +
> +                       /* VT6212: EHCI sleep time 10us (default 1) */
> +                       pci_read_config_byte(pdev, 0x4b, &tmp);
> +                       pci_write_config_byte(pdev, 0x4b, tmp | 0x20);
> +               }
> +               break;



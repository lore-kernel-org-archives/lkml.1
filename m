Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbXJBNUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbXJBNUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 09:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753160AbXJBNUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 09:20:44 -0400
Received: from mail-gw3.adaptec.com ([162.62.93.58]:48360 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbXJBNUo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 09:20:44 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Oct 2007 09:20:44 EDT
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: kdump detection in SCSI drivers
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Tue, 2 Oct 2007 09:10:20 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01E8BB79@otce2k301.adaptec.com>
In-Reply-To: <20071002080000.GA5743@atrey.karlin.mff.cuni.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: kdump detection in SCSI drivers
Thread-Index: AcgEyle4Qlxb7h4BR8u0XeH+hUo5DwAKjO+g
References: <9738BCBE884FDB42801FAD8A7769C26501B2C44C@NAMAIL1.ad.lsil.com> <20070920104249.GB12157@atrey.karlin.mff.cuni.cz> <9738BCBE884FDB42801FAD8A7769C26501B2C7D8@NAMAIL1.ad.lsil.com> <20071002080000.GA5743@atrey.karlin.mff.cuni.cz>
From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
To: "Pavel Machek" <pavel@ucw.cz>, "Mukker, Atul" <Atul.Mukker@lsi.com>
Cc: <Linux-scsi@vger.kernel.org>, "Vivek Goyal" <vgoyal@in.ibm.com>,
       <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek sez:
> > Other suggestion which came about was to parse the kernel
> > command line and look for "elfcorehdr=". Is this ok? Is
> > kernel command line visible to the SCSI drivers?
> Kernel command line probably is visible, but I'd recommend
> against doing that.

Probably just as pregnant of a plan, what about looking for the
reset_devices being none-zero? It was introduced for kdump to address
the problem with devices that maintain state outside of the driver and
the intent is to have it always set in the kdump kernel context.

Personally, I'd code the driver to acquire memory normally, and have a
backup plan to acquire less should the allocation fail in a memory
limited environment ;-/

Sincerely -- Mark Salyzyn

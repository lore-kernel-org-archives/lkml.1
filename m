Return-Path: <linux-kernel-owner+w=401wt.eu-S933864AbZLOWBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864AbZLOWBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 17:01:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933851AbZLOWBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 17:01:06 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:48174 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933850AbZLOWBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 17:01:05 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: K8 ECC error with linux-2.6.32
Date: Tue, 15 Dec 2009 23:00:46 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32; KDE/4.3.4; x86_64; ; )
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org
References: <200912112202.48173.johannes.hirte@fem.tu-ilmenau.de> <200912150808.04814.johannes.hirte@fem.tu-ilmenau.de> <20091215153026.GD20880@aftab>
In-Reply-To: <20091215153026.GD20880@aftab>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912152300.46325.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 15 Dezember 2009 16:30:26 schrieb Borislav Petkov:
> On Tue, Dec 15, 2009 at 08:08:04AM +0100, Johannes Hirte wrote:
> >  Northbridge Error, node 0, core: -1
> > amd_decode_nb_mce: NBSL: 0x0005001b, NBSL: 0xa4000000
> > K8 ECC error.
> 
> Yep, this is a benign GART TLB error which is not being reported but
> you're using the amd64_edac module and it trips since the error is still
> being logged and the module sees it. There are two fixes:
> 
> 1. If you have a BIOS option with a wording like:
> 
> "Gart Table Walk Error MC reporting: Disabled/Enabled."
> 
> which should disable it.

Yes, there is such an option that was enabled. I was shure I had disabled it, 
especially as the BIOS help says too that it's only for graphic driver 
developers. I've disabled it now, will test the patch later.

> 2. If no BIOS option, the patch below should fix it. Can you please
> test (against v2.6.32).

This patch (as the BIOS option) will only disable the error reports. The error 
itself will still occur, right? So necessary to find out why the radeon driver 
trigger this error.


regards,
  Johannes

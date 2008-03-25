Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbYCYXrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbYCYXrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 19:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756231AbYCYXrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 19:47:23 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:38882 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYCYXrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 19:47:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=oLBTAD486eskfBAmlyIRGFqzMI1HL+/lG0I8IJ+SlviKMU62TZzwu7sDZuZEwk9CE+f2vsOiaRCoWSyblh5eOxvlk74GVWgiAOFNVzm8yk9k/Ee28pklpCaEfhW5fnhL040AbtXjVk1CfQTZqt4u5Hcctpf9ZRb9JWW+90LwF38=
Message-ID: <998d0e4a0803251647i2abefe96t34ec4ad6706afcfd@mail.gmail.com>
Date: Wed, 26 Mar 2008 00:47:16 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: "David Miller" <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: larger default page sizes...
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar 2008 16:22:44 -0700 (PDT), David Miller wrote:
> > On Mon, 24 Mar 2008, David Miller wrote:
> >
> > > There are ways to get large pages into the process address space for
> > > compute bound tasks, without suffering the well known negative side
> > > effects of using larger pages for everything.
> >
> > These hacks have limitations. F.e. they do not deal with I/O and
> > require application changes.
>
> Transparent automatic hugepages are definitely doable, I don't know
> why you think this requires application changes.
>
> People want these larger pages for HPC apps.

But there is a general problem of larger pages in systems that
don't support them natively (in hardware) depending in how it's
implemented the memory manager in the kernel:

   "Doubling the soft page size implies
      halfing the TLB soft-entries in the old hardware".

   "x4 soft page size=> 1/4 TLB soft-entries, ... and so on."

Assuming one soft double-sized page represents 2 real-sized pages,
one replacing of one soft double-sized page implies replacing
2 TLB's entries containing the 2 real-sized pages.

The TLB is very small, its entries are around 24 entries aprox. in
some processors!.

Assuming soft 64 KiB page using real 4 KiB pages => 1/16 TLB soft-entries.
If the TLB has 24 entries then calculating 24/16=1.5 soft-entries,
   the TLB will have only 1 soft-entry for soft 64 KiB pages!!! Weird!!!

The normal soft sizes are 8 KiB or 16 KiB for non-native processors, not more.
  So, the TLB of 24 entries of real 4 KiB will have 12 or 6
soft-entries respect.

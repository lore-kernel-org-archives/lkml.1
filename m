Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbXFLSx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbXFLSx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756994AbXFLSxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:53:17 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:47635 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756516AbXFLSxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:53:16 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andi Drebes <lists-receive@programmierforen.de>
Subject: Re: [KJ] [PATCH] drivers/acpi: sizeof/sizeof array size calculations replaced with ARRAY_SIZE
Date: Tue, 12 Jun 2007 12:53:07 -0600
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, Christoph Hellwig <hch@infradead.org>,
       Len Brown <lenb@kernel.org>, kernel-janitors@lists.osdl.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200705261239.27485.lists-receive@programmierforen.de> <200706101544.35463.bjorn.helgaas@hp.com> <200706122041.06252.lists-receive@programmierforen.de>
In-Reply-To: <200706122041.06252.lists-receive@programmierforen.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706121253.07395.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2007 12:41:05 pm Andi Drebes wrote:
> First off: sorry for my late answer.
> 
> > I agree the ACPI CA is a nuisance.  But in this case, we're making
> > a mountain out of a molehill.  I suspect that if somebody spent the
> > 15 minutes to make the ARRAY_SIZE patch work in both the Linux ACPI CA
> > and the generic Intel one and license it appropriately, Len would
> > happily apply the patch.
> I hope I got everything right. Here's what I understood so far:
> 
> The ACPI Subsystem in the kernel is derived from intel sources. I searched
> the web for information about that and finally found
> 
> http://www.intel.com/technology/iapc/acpi/downloads.htm
> 
> Is that the right one? So what I would have to do in order to
> "make the ARRAY_SIZE patch work in both the Linux ACPI CA
> and the generic Intel one" is to modify those sources aswell,
> send a patch to Intel and another one back to the
> lkml.

You found the right one.  The ACPI CA in Linux is really the same
as the one from Intel.  Len integrates the Intel one into Linux
periodically.  He uses scripts or something to format it so it looks
more like Linux.

I think Len sometimes takes patches against the "Linux-ized" ACPI CA.
He probably has to apply those by hand to the Intel one, which is
the real "upstream" in this case.  So it might be a bit easier for
him if you generated a diff against the Intel version.  Then it
would show up in Linux, too, in the fullness of time.

In any event, you want to end up with one patch, not two.

You probably would have to add something like:

  #ifndef ARRAY_SIZE
  #define ARRAY_SIZE(x) ...
  #endif

somewhere in the ACPI CA header files.  That way it will work in
non-Linux OSes as well.

Bjorn

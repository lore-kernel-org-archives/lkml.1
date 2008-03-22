Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbYCVUuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbYCVUuV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 16:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbYCVUuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 16:50:06 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4118 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754966AbYCVUuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 16:50:04 -0400
Date: Sat, 22 Mar 2008 16:49:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Pavel Machek <pavel@ucw.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
       <nigel@nigel.suspend2.net>,
       Kexec Mailing List <kexec@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-pm@lists.linux-foundation.org>, Vivek Goyal <vgoyal@redhat.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [linux-pm] [PATCH -mm] kexec jump -v9
In-Reply-To: <200803221845.13826.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0803221645190.27399-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Rafael J. Wysocki wrote:

> However, as far as the ACPI NVS area is concerned, this is probably not
> necessary, because the spec wants us to restore the ACPI NVS before calling
> _WAK, which is just after the image kernel gets the control back.  So, in
> theory, the ACPI NVS data could be stored in the image and restored by
> the image kernel from a location known to it (the procedure may be to copy
> the ACPI NVS data into a region of regular RAM before creating the image and
> copy them back into the ACPI NVS area in platform->leave(), for example), but
> I suspect that for this to work we'll have to switch ACPI off in the boot
> kernel, just prior to passing control back to the image kernel.

That sounds by far the simplest solution.  If the boot kernel can tell
(by looking at some header field in the image or any other way) that
the hibernation used S5 instead of S4, then it should just turn off 
ACPI before passing control to the image kernel.  Then the image kernel 
can turn ACPI back on and all should be well.  If you do this, does the 
NVS region still need to be preserved?

Alan Stern


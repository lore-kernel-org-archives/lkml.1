Return-Path: <linux-kernel-owner+w=401wt.eu-S1946880AbXD3W7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946880AbXD3W7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 18:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946881AbXD3W7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 18:59:22 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:4627 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946880AbXD3W7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 18:59:20 -0400
Date: Tue, 1 May 2007 00:59:16 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Message-ID: <20070430225916.GA39223@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Robert Hancock <hancockr@shaw.ca>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <ak@suse.de>,
	Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4635510D.4060103@shaw.ca>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 08:14:37PM -0600, Robert Hancock wrote:
> -Validate that the area is reserved even if we read it from the
> chipset directly and not from the MCFG table. This catches the case
> where the BIOS didn't set the location properly in the chipset and
> has mapped it over other things it shouldn't have.  This might be
> overly pessimistic - we might be able to instead verify that no
> other reserved resources (like chipset registers) are inside this
> memory range.

I have a fundamental problem with that: you don't validate a higher
reliability information against a lower one.  The chipset registers
are high reliability.  Modulo unknown hardware erratas and bugs in the
code (and accepting f0000000 is in practice a bug in the code, the
docs are starting to catch up with it too), the chipset *will* decode
mmconfig at the looked up address no matter what.  On the other side,
the ACPI data is bios generated, and that is well known to be horribly
unreliable.  Hell, if it was reliable we could just use the MFCG ACPI
table without questions.

So you can check the ACPI stuff for coherency (MFCG vs. the rest), you
can validate the ACPI stuff against the results of the lookup if you
want, but validating the lookup against ACPI is nonsensical.

  OG.


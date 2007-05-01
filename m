Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbXEAQzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbXEAQzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbXEAQzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:55:54 -0400
Received: from outbound-mail-25.bluehost.com ([69.89.21.20]:44792 "HELO
	outbound-mail-25.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754779AbXEAQzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:55:53 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 May 2007 12:55:53 EDT
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Olivier Galibert <galibert@pobox.com>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI motherboard resources
Date: Tue, 1 May 2007 09:48:46 -0700
User-Agent: KMail/1.9.6
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Chuck Ebbert <cebbert@redhat.com>, Len Brown <lenb@kernel.org>
References: <4635510D.4060103@shaw.ca> <20070430225916.GA39223@dspnet.fr.eu.org>
In-Reply-To: <20070430225916.GA39223@dspnet.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705010948.46458.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.73.10 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 30, 2007, Olivier Galibert wrote:
> On Sun, Apr 29, 2007 at 08:14:37PM -0600, Robert Hancock wrote:
> > -Validate that the area is reserved even if we read it from the
> > chipset directly and not from the MCFG table. This catches the case
> > where the BIOS didn't set the location properly in the chipset and
> > has mapped it over other things it shouldn't have.  This might be
> > overly pessimistic - we might be able to instead verify that no
> > other reserved resources (like chipset registers) are inside this
> > memory range.
>
> I have a fundamental problem with that: you don't validate a higher
> reliability information against a lower one.  The chipset registers
> are high reliability.  Modulo unknown hardware erratas and bugs in the
> code (and accepting f0000000 is in practice a bug in the code, the
> docs are starting to catch up with it too), the chipset *will* decode
> mmconfig at the looked up address no matter what.  On the other side,
> the ACPI data is bios generated, and that is well known to be horribly
> unreliable.  Hell, if it was reliable we could just use the MFCG ACPI
> table without questions.

We need to look at the register, but we may not want to use it if it looks 
too confused.  If it doesn't agree with what we see in ACPI, we likely 
have a problem due to the issues Robert outlined in his other mail.

Jesse


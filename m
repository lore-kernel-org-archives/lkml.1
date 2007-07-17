Return-Path: <linux-kernel-owner+w=401wt.eu-S934055AbXGQPIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055AbXGQPIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933810AbXGQPIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:08:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:22963 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932826AbXGQPIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:08:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=KpUEbjD4x7wkN8USgECGnagGZBEWWgYkpCetej/E6x2hrgThEV864MgQS9lHc/NJr
	CX8sR27xcwEKlxqb8vw2g==
Message-ID: <8f95bb250707170808n19799ba5l3acd13e2ee7e0f08@mail.gmail.com>
Date: Tue, 17 Jul 2007 08:08:19 -0700
From: "Aaron Durbin" <adurbin@google.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] ACPI: Add reboot mechanism
Cc: "Andi Kleen" <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com, akpm@osdl.org
In-Reply-To: <86802c440707170740i30ed2110l130dafbec8e4d4a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070716180019.GA5112@google.com> <200707171331.59414.ak@suse.de>
	 <86802c440707170740i30ed2110l130dafbec8e4d4a5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/17/07, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On 7/17/07, Andi Kleen <ak@suse.de> wrote:
> > On Monday 16 July 2007 20:00:19 Aaron Durbin wrote:
> > >
> > > Add the ability to reset the machine using the RESET_REG in ACPI's FADT table.
> >
> > Why? I had such a patch at some point as experiment, but it never
> > helped actually fix a box.
> >
> system without superio, should still have SMI to simulate one keyboard
> controller. So the key board reset still works.

This is true if SMIs are still flowing, and the SMI handler correctly handles
the reset properly. I have seen cases where the SMI handler is broken which
causes the system to perpetually hang. Utilizing the exposed reset mechanism
in ACPI should reset the system every time. However, if the reset fails it
will fall back to the keyboard controller.

-Aaron

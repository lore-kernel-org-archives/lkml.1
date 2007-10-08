Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbXJHHp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbXJHHp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 03:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751755AbXJHHpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 03:45:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXJHHpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 03:45:15 -0400
Message-ID: <4709DFD5.5050900@redhat.com>
Date: Mon, 08 Oct 2007 09:44:21 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Scott <linux-kernel@bluecamel.eml.cc>
CC: Robert Hancock <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
Subject: Re: cx88 pci_abort messages
References: <fa.9BwFZjxkV7dKD7EmsWMTtKId3Qc@ifi.uio.no>	 <fa.m+2QwZVzW3oTWJBsJ4fdAiUZWkM@ifi.uio.no>  <4707D876.8080306@shaw.ca> <1191705303.7536.6.camel@oasis.donpoo.home>
In-Reply-To: <1191705303.7536.6.camel@oasis.donpoo.home>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Scott wrote:
> On Sat, 2007-10-06 at 12:48 -0600, Robert Hancock wrote:
>>>> Oct  2 21:59:32 htpc cx88[0]: irq mpeg  [0x80000] pci_abort*
>>>> Oct  2 21:59:32 htpc cx88[0]/2-mpeg: general errors: 0x0008000

> I assumed it was an interrupt issue based on the 'irq mepg' error, not a
> DMA issue.

It's a DMA issue.  The chip raised an irq to signal the error condition
to the driver, thats why it is printed by the irq handler.  Happened
while streamimg mpeg data.

Havn't looked at the code for years now, but IIRC the 0x800000 is the
raw error code from some status register, pci_abort is the error bit in
clear text, meaning some PCI DMA transfer was aborted.  No idea why
though ...

cheers,
  Gerd

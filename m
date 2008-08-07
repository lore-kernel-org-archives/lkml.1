Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYHGDaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYHGDaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 23:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYHGDaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 23:30:00 -0400
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:28430 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753037AbYHGD37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 23:29:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=A92GyyhH8NVJpyWKH2L55/+W7LtWVgT2AV6oz8d5zuT2MGscANsnSwsUgvMMYowp9iYet5V9k0/O9aj0VRCP7Bq7vyccryqz6v4QS8MWMs0W1biE0AYSFCCpNLdCoMYrRJ7nnAKZ+glY0TY71E3I00cj92EGwmdIjpG2QLmw2SU=  ;
X-YMail-OSG: q.L9eIwVM1mZWf9yoCEBNzvMepFxnnlPb3n34.Nrl7f2V.vB70L_ojBBWwXLlLRAglzK589WUExQdEXOIG0oavGngKSEKQcXOvssk3dPZebCZU_GutNXU_XECNjchyhrHTNDzk24ILcHhd.2UbqykQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>, Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH RFC] USB: Add HCD fastboot
Date: Wed, 6 Aug 2008 20:29:56 -0700
User-Agent: KMail/1.9.9
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <Pine.LNX.4.44L0.0808061828010.2145-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808061828010.2145-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200808062029.56844.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Lack of a keyboard makes it impossible to do anything if the module fails to 
> > load... as I understand it when the HCD init runs, any BIOS emulation stops?
> 
> That's right.  The host driver kicks the BIOS off the hardware.

That's done much earlier ... as part of PCI quirk handling.
See drivers/usb/host/pci-quirks.c ... it's not been part of
the HCDs for about three years now.  I don't recall the details
right now, but letting the BIOS hang on to that hardware was
causing a lot of wierd problems that went away when we made
that change.

If a module fails to load, fix the bug in that module.  :)

- Dave


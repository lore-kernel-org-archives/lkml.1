Return-Path: <linux-kernel-owner+w=401wt.eu-S1760761AbZLJX4E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbZLJX4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 18:56:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759126AbZLJX4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 18:56:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758016AbZLJX4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 18:56:01 -0500
Date: Thu, 10 Dec 2009 21:55:50 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Problems with serial interrupts with IPMI 2.0 SoL
Message-ID: <20091210215550.7f092006@pedra>
In-Reply-To: <4B216C12.1020001@goop.org>
References: <4B216C12.1020001@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, 10 Dec 2009 13:45:54 -0800
Jeremy Fitzhardinge <jeremy@goop.org> escreveu:

> Hi,
> 
> I'm using a system with an embedded IPMI 2.0 BMC which provides SoL 
> (Supermicro X8SIL-F).  This works fine under Linux (fully interrupt 
> driven), but fails for Xen as it appears to not be sending interrupts; 
> it works OK if I set the driver to polling mode.
> 
> I'm assuming the Xen is tickling some bug in the emulated 16550.  The 
> Linux driver has a couple of pieces of code to explicitly work around 
> bugs in the Intel AMT SoL implementation, but I don't think they're 
> coming into play here (because there are no Intel SoL PCI devices on 
> this system to trigger the NO_TXEN_TEST flag).
> 
> I'm wondering if you have any pointers or suggestions about more subtle 
> problems?

If you don't hit NO_TXEN_TEST flag, you'll be loosing interrupts, as the
emulation of 16550 is not perfect.

As far as I remember, interrupts take too long to happen with the emulated
16550, when comparing with a normal serial.

-- 

Cheers,
Mauro

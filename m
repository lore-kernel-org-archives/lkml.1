Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbYLNIWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbYLNIWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755273AbYLNIMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:12:24 -0500
Received: from colo.lackof.org ([198.49.126.79]:43304 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306AbYLNIMX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:12:23 -0500
Date: Sun, 14 Dec 2008 01:12:10 -0700
From: Grant Grundler <grundler@parisc-linux.org>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: MSI messages
Message-ID: <20081214081210.GC13371@colo.lackof.org>
References: <49438290.1080502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49438290.1080502@gmail.com>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 13, 2008 at 01:38:24PM +0400, Manu Abraham wrote:
> Hi,
> 
> I am wondering how to handle this:
> 
> Does the kernel somehow handle MSI message readback from the PCI config space 
> for the MSI message as described in 6.8.1 of the PCI Bus specification 2.3 or 
> does a device specific driver have to read the Message Address and Data ?
> 
> To put it short: i am wondering how i should read the MSI messages.

The "message" is actually mapped to an the interrupt vector by the core
generic interrupt handling code in the kernel.

A "GSI" (Generic Sys Interrupt?) is associated with each entry in
the MSI-X table. Driver then calls request_irq() to bind an interrupt
handler to each GSI. So the driver never directly sees the "message".

hth,
grant

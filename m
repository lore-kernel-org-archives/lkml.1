Return-Path: <linux-kernel-owner+w=401wt.eu-S1762886AbZANPrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762886AbZANPrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 10:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753669AbZANPrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 10:47:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:42345 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753540AbZANPrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 10:47:07 -0500
Date: Wed, 14 Jan 2009 10:47:05 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: A really interesting mass-storage BUG introduced after 2.6.18
In-Reply-To: <496C7AC9.3040303@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.0901141041070.2192-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2009, [UTF-8] Ozan Çağlayan wrote:

> Here's the usbmon log:
...

Here's the interesting part, right at the end of the log:

> ee5f0e80 2495844993 S Bo:1:011:1 -115 31 = 55534243 02000000 00000000 00000600 00000000 00000000 00000000 000000
> ee5f0e80 2495845078 C Bo:1:011:1 0 31 >
> ee5f0e80 2495845112 S Bi:1:011:2 -115 13 <
> ee5f0e80 2495845327 C Bi:1:011:2 0 13 = 55534253 02000000 00000000 01
> ee5f0e80 2495845338 S Bo:1:011:1 -115 31 = 55534243 03000000 12000000 80000603 00000012 00000000 00000000 000000
> ee5f0e80 2495845579 C Bo:1:011:1 0 31 >
> ee4d7280 2495845595 S Bi:1:011:2 -115 18 <
> ee4d7280 2495845829 C Bi:1:011:2 0 18 = 70000600 0000000a 00000000 3a000000 0000
> ee5f0e80 2495845850 S Bi:1:011:2 -115 13 <
> ee5f0e80 2495845955 C Bi:1:011:2 0 13 = 55534253 03000000 00000000 00

This shows the computer sending a TEST UNIT READY command to the drive, 
and the drive reporting Unit Attention: Media not present.  So of 
course Linux believes there is no media loaded in the drive and doesn't 
try to read the partition table or anything else.

Presumably if the drive is plugged in during bootup then the BIOS does 
something to make this error status go away.  It's hard to guess what 
that would be, however.

Alan Stern


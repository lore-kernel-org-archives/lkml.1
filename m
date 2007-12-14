Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbXLNFVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbXLNFVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 00:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbXLNFUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 00:20:48 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:22556 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbXLNFUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 00:20:47 -0500
Date: Thu, 13 Dec 2007 23:20:31 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: ATA ACPI needs "Mr interpreter, would you please shut up?" flag
In-reply-to: <47620E5E.5020001@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>
Message-id: <4762129F.6060209@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <47620E5E.5020001@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello, all.
> 
> During 2.6.24-rc1, libata enabled ATA-ACPI support by default and there
> have been a lot of regression reports stemming from it.  I have patchset
> ready to fix most of the problems.  With these patches applied, libata
> should be able to cope with most failures pretty well.  There is one
> remaining issue tho.
> 
> libata caches the result of _GTM during controller for later use.  The
> primary use is to peek at how BIOS configured the controller.  Some
> controllers (pata_via and pata_amd) lack proper cable detection and BIOS
> configured values are used as reference.  This caching is done before
> any other operation is performed on the port to avoid caching corrupted
> data.
> 
> Problem is that _GTM implementation on certain BIOSen crap themselves if
> invoked on empty channels.  However, as written above, because initial
> _GTM caching is done before any actual operation is performed on the
> port, libata can't determine whether the port is occupied or not when
> trying to cache _GTM result.  Unfortunately, VIA PATA is on both
> categories - it needs _GTM caching but can't cope with _GTM invocation
> on empty ports.  Yay!

I seem to have lost the thread/bug report where we decided that one 
board always choked on an empty channel. Maybe it's not that and it's 
just another case of the same issue where our resetting default timing 
values on the controller before calling _GTM would choke the _GTM method?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/



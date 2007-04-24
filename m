Return-Path: <linux-kernel-owner+w=401wt.eu-S1754657AbXDXXrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbXDXXrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 19:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbXDXXrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 19:47:42 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:24799 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbXDXXrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 19:47:41 -0400
Date: Tue, 24 Apr 2007 17:47:33 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: old ISA DMA bug in 2.6.12?
In-reply-to: <fa.7m5DEEaYclDeS/YSPViAnSljQHI@ifi.uio.no>
To: Bob Tracy <rct@gherkin.frus.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <462E9715.60304@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.7m5DEEaYclDeS/YSPViAnSljQHI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bob Tracy wrote:
> I was enjoying yet another session of beating my head against the wall
> trying to do useful things with old hardware :-), and managed to cause a
> kernel panic by simply trying to mount a cdrom in the context of a DSL-N
> installation.
> 
> The SCSI host adapter is an Adaptec AHA-1542B, and when I try to mount a
> cdrom, I manage to run afoul of the BAD_DMA() check in aha1542.c: the
> buffer returned is not in the lower 16 MB of memory.
> 
> The same 2.6.12 kernel + hardware combination works fine as long as I
> confine my I/O to the hard disk that's also attached to the AHA-1542B.

Looks like the aha1542 driver doesn't set the DMA mask, so the kernel 
will default to thinking it can do 32-bit DMA when it should be 24-bit.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbYFETRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbYFETRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 15:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYFETRE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 15:17:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35635 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbYFETRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 15:17:03 -0400
Message-ID: <48483BA9.1070200@garzik.org>
Date: Thu, 05 Jun 2008 15:16:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] firmware: moving drivers to request_firmware()
References: <20080605.foo@pmac.infradead.org>
In-Reply-To: <20080605.foo@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> Ignoring the set of 'make fw->data const' patches which have mostly
> been already posted and are fairly trivial, this is the current content
> of the firmware tree at git.infradead.org/users/dwmw2/firmware-2.6.git
> 
> It starts by giving a way to build arbitrary firmware blobs into the
> kernel while letting request_firmware() find them there, and then sets
> about converting drivers to use request_firmware() instead of static
> data blobs, now that we can do that without forcing the users to
> actually  satisfy the firmware requests from userspace.
> 
> Rather than including binary blobs in the git tree, we carry them as
> .ihex files -- which as an added bonus can have comments and licensing
> information appended after the EOF record.
> 
> For the USB drivers which actually _want_ Intel HEX files in their
> original form as individual records, we have a binary representation
> of such and a tool to convert the original .HEX files into .fw files
> in that form. And associated helpers in the kernel for validating and
> using them. 
> 
> We also add a 'make firmware_install' target, which is intended to
> install the firmware blobs into /lib/firmware/ where the userspace
> loader to find them.

Why do we need the .ihex format?

We should be loading firmwares exactly as they come from the vendor, 
without any wrappers.

	Jeff





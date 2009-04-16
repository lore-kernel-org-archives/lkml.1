Return-Path: <linux-kernel-owner+w=401wt.eu-S1754928AbZDPVGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928AbZDPVGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 17:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbZDPVGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 17:06:08 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:50049 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbZDPVGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 17:06:07 -0400
Date: Thu, 16 Apr 2009 16:58:56 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Chris Friesen <cfriesen@nortel.com>
cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: how to tell if arbitrary kernel memory address is backed by
 physical memory?
In-Reply-To: <49E750CA.4060300@nortel.com>
Message-ID: <alpine.DEB.1.10.0904161654480.7855@qirst.com>
References: <49E750CA.4060300@nortel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Apr 2009, Chris Friesen wrote:

> Quick question to the memory management folks.
>
> Is there a portable way to tell whether a particular virtual address in the
> lowmem address range is backed by physical memory and is readable?
>
> For background...we have some guys working on a software memory scrubber for
> an embedded board.  The memory controller supports ECC but doesn't support
> scrubbing  in hardware.  What we want to do is walk all of lowmem, reading in
> memory.  If a fault is encountered, it will be handled by other code.

Virtual address in the lowmem address range? lowmem address ranges exist
for physical addresses.

If you walk lowmem (physical) then you will never see a missing page.

So I guess you have a process that wants to determine if its memory is
present? See

	man 2 mincore

which describes a glibc call that shows which pages of a process are
present.



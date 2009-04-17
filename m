Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbZDQQfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbZDQQfQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 12:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758887AbZDQQe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 12:34:59 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:58729 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758809AbZDQQe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 12:34:58 -0400
Date: Fri, 17 Apr 2009 12:27:43 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Chris Friesen <cfriesen@nortel.com>
cc: linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
Subject: Re: how to tell if arbitrary kernel memory address is backed by
 physical memory?
In-Reply-To: <49E8AB11.4000708@nortel.com>
Message-ID: <alpine.DEB.1.10.0904171224530.7261@qirst.com>
References: <49E750CA.4060300@nortel.com> <alpine.DEB.1.10.0904161654480.7855@qirst.com> <49E8AB11.4000708@nortel.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 17 Apr 2009, Chris Friesen wrote:

> We have a mips board that appears to have holes in the lowmem mappings such
> that blindly walking all of it causes problems.  I assume the allocator knows
> about these holes and simply doesn't assign memory at those addresses.

Yes memory is registered in distinct ranges during boot.

> We may have found a solution though...it looks like virt_addr_valid() returns
> false for the problematic addresses.  Would it be reasonable to call this once
> for each page before trying to access it?

Sure. Note that virt_addr_valid only ensures that there is a page
struct for that address. You may need to ensure that PageReserved(page) is
false if you want to make sure that you have actual memory there that is
valid to use.


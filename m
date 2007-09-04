Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbXIDTD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbXIDTD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 15:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbXIDTDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 15:03:20 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56267 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310AbXIDTDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 15:03:20 -0400
Subject: Re: [-mm PATCH]  Memory controller improve user interface (v3)
From: Dave Hansen <haveblue@us.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>
In-Reply-To: <20070902105021.3737.31251.sendpatchset@balbir-laptop>
References: <20070902105021.3737.31251.sendpatchset@balbir-laptop>
Content-Type: text/plain
Date: Tue, 04 Sep 2007 12:03:13 -0700
Message-Id: <1188932593.28903.357.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-09-02 at 16:20 +0530, Balbir Singh wrote:
> 
> +Setting a limit to a number that is not a multiple of page size causes
> +rounding up of the value. The user must check back to see (by reading
> +memory.limit_in_bytes), to check for differences between desired values and
> +committed values. Currently, all accounting is done in multiples of PAGE_SIZE 

I wonder if we can say this in a bit more generic fashion.

        A successful write to this file does not guarantee a successful
        set of this limit to the value written into the file.  This can
        be due to a number of factors, such as rounding up to page
        boundaries or the total availability of memory on the system.
        The user is required to re-read this file after a write to
        guarantee the value committed by the kernel.

This keeps a user from saying "I page aligned the value I stuck in
there, no I don't have to check it."

-- Dave


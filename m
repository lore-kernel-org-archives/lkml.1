Return-Path: <linux-kernel-owner+w=401wt.eu-S935987AbXGUH5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935987AbXGUH5z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 03:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757260AbXGUH5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 03:57:48 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41470 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758662AbXGUH5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 03:57:47 -0400
Message-ID: <385004657.19525@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Sat, 21 Jul 2007 15:57:44 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 7/7] readahead: basic support of interleaved reads
Message-ID: <20070721075744.GA10790@mail.ustc.edu.cn>
Mail-Followup-To: Rusty Russell <rusty@rustcorp.com.au>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Andi Kleen <andi@firstfloor.org>
References: <20070721044300.909424569@mail.ustc.edu.cn> <20070721044347.388744012@mail.ustc.edu.cn> <1185002679.6344.30.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1185002679.6344.30.camel@localhost.localdomain>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2007 at 05:24:39PM +1000, Rusty Russell wrote:
> 	This is really clever!

Thank you :)

> 	Only one slight complaint: I wonder if "radix_tree_scan_hole" could be
> expressed as "radix_tree_extent_size" which return the number of

In fact the full context based readahead requires three functions:

        - radix_tree_scan_hole(root, index, max_scan)                                                                   
        - radix_tree_scan_hole_backward(root, index, max_scan)                                                          
        - radix_tree_scan_data_backward(root, index, max_scan)                                                          

I would be very glad if you can work up a consistent naming scheme
for them all ;)

> populated indices up to "max_scan".  Returning a length seems more
> intuitive to me (and I think gets rid of the wraparound error case?)

No, changing the return value won't eliminate the wraparound case.

But I guess we can safely assume that it won't wrap around at all?
The last page in the pagecache address space will not be
granted/allocated thanks to the not-too-aggressive MAX_LFS_FILESIZE?


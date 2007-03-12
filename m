Return-Path: <linux-kernel-owner+w=401wt.eu-S1030654AbXCLQrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030654AbXCLQrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030653AbXCLQrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:47:19 -0400
Received: from services106.cs.uwaterloo.ca ([129.97.152.164]:53595 "EHLO
	services106.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030654AbXCLQrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:47:06 -0400
Date: Mon, 12 Mar 2007 12:46:47 -0400 (EDT)
From: Ashif Harji <asharji@cs.uwaterloo.ca>
To: Jan Kara <jack@suse.cz>
cc: linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: do_generic_mapping_read performance issue
In-Reply-To: <20070312142012.GH30777@atrey.karlin.mff.cuni.cz>
Message-ID: <Pine.GSO.4.64.0703121230520.7679@cpu102.cs.uwaterloo.ca>
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca>
 <20070312142012.GH30777@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0 (services106.cs.uwaterloo.ca [129.97.152.132]); Mon, 12 Mar 2007 12:47:00 -0400 (EDT)
X-Miltered: at aeacus with ID 45F58403.000 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 193620dd-c0fb-4f13-9f9c-6f06b6f4e347
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> The implication of this code is that for files of size less than or equal
>> to a single page, the page associated with such a file is likely to get
>> evicted from the cache regardless of how frequently it is accessed.  The
>> reason is that after the first access, prev_index is always zero and index
>> can only be zero. Hence, mark_page_accessed is never called after the
>> first time the file is requested.  As a result, the page is evicted from
>> the cache no matter how frequently it is used.  By changing the kernel to
>> always call mark_page_accessed for these files, the server throughput is
>> increased by as much as 20%.
>  Your analysis seems to be right. But to observe this behaviour you have
> to have the file open and just always reread it using the same file
> descriptor, don't you? That's probably not too common...

Yes, this problem requires the file to be accessed via the same file 
descriptor.  I suspect this behaviour is common for a certain class of 
applications, e.g., web servers.  However, any application that read from 
the same page repeatedly would also experience this problem.  It is more 
likely to occur with small files, but not exculsively.

ashif.

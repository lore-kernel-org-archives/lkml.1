Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653Ab0AUPjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab0AUPjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 10:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514Ab0AUPji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 10:39:38 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:56330 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab0AUPje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 10:39:34 -0500
Message-ID: <4B58740F.7050400@nortel.com>
Date: Thu, 21 Jan 2010 09:34:39 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: issues with kmemleak backport
References: <4B55F3EF.9020408@nortel.com> <4B561D8D.1000003@nortel.com>	 <4B574297.7070504@nortel.com> <1264028299.5185.20.camel@pc1117.cambridge.arm.com>
In-Reply-To: <1264028299.5185.20.camel@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Jan 2010 15:39:29.0545 (UTC) FILETIME=[EB8EF790:01CA9AAF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 04:58 PM, Catalin Marinas wrote:
> Hi,
> 
> First of all, apart from backporting the kmemleak patches I would
> suggest you do a kernel grep for kmemleak_* function calls as there may
> be explicit cases where allocated memory blocks are ignored from
> scanning (like the AGP aperture which is unmapped from the standard
> kernel linear mapping).

Thanks for the suggestion.  I'll do that.

> Alternatively, until you get this to work, just modify kmemleak to dump
> information it has about every object it scans via dump_object_info()
> called from scan_object(). The amount of information is quite large but
> at least you should see the last block that it fails to scan and maybe
> add a kmemleak_ignore() on the block allocation site.

I finally got access to a 64-bit lab system and there the backport seems
to be working just fine.  Since that's were I actually need it, life is
now much better.  :)

If I run into more issues I'll try using your ideas to work around the
issue.

Thanks,

Chris

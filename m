Return-Path: <linux-kernel-owner+w=401wt.eu-S1030259AbXDMWVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030259AbXDMWVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030853AbXDMWVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:21:13 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:43112 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030259AbXDMWVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:21:13 -0400
Message-ID: <462001A9.3030006@vmware.com>
Date: Fri, 13 Apr 2007 15:18:17 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: For debugging, make the initial page table setup
 less forgiving.
References: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>
In-Reply-To: <200704132149.l3DLnvUY012097@tazenda.hos.anvin.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> +	/*
> +	 * End condition: we must map up to and including
> +	 * INIT_MAP_BEYOND_END bytes beyond the end of our
> +	 * own page tables; 0x1000 is the size of the page
> +	 * table were about to write, and +0x007 is the
> +	 * attribute bits.
> +	 */
> +	leal (INIT_MAP_BEYOND_END+0x1000+0x007)(%edi),%ebp
>   

hrmm?  Shouldn't that still be INIT_MAP_BEYOND_END+0x0007?  Seems you 
are mapping 4M more than you need.

Zach

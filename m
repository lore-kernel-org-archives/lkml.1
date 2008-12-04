Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbYLDTjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbYLDTjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 14:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYLDTjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 14:39:22 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:6382 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbYLDTjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 14:39:21 -0500
Message-ID: <493831A9.3050904@caviumnetworks.com>
Date: Thu, 04 Dec 2008 11:38:17 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: prasad@linux.vnet.ibm.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>, akpm@linux-foundation.org,
       mingo@elte.hu, richardj_moore@uk.ibm.com
Subject: Re: [RFC Patch 1/9] Introducing generic hardware breakpoint handler
 interfaces
References: <20081204190804.GA15134@in.ibm.com> <20081204191119.GA20563@in.ibm.com>
In-Reply-To: <20081204191119.GA20563@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Dec 2008 19:38:17.0382 (UTC) FILETIME=[DB02A460:01C95647]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K.Prasad wrote:
[...]
> + * len and type values are defined in include/asm/hw_breakpoint.h.
> + * Available values vary according to the architecture.  On i386 the
> + * possibilities are:
> + *
> + *	HW_BREAKPOINT_LEN_1
> + *	HW_BREAKPOINT_LEN_2
> + *	HW_BREAKPOINT_LEN_4
> + *	HW_BREAKPOINT_LEN_EXECUTE
> + *	HW_BREAKPOINT_RW
> + *	HW_BREAKPOINT_READ
> + *	HW_BREAKPOINT_EXECUTE
> + *
> + * On other architectures HW_BREAKPOINT_LEN_8 may be available, and the
> + * 1-, 2-, and 4-byte lengths may be unavailable.  There also may be
> + * HW_BREAKPOINT_WRITE.  You can use #ifdef to check at compile time.
> + */

On MIPS we support breakpoint lengths that are powers of 2 between 8 and 
4096.  Do you really want symbolic values for these?  The debuggers have 
to do calculations with the length values, so translating between the 
symbolic values and numeric values would be tedious at best.


David Daney

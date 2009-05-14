Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbZENLht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbZENLht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754551AbZENLhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:37:40 -0400
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:59439 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbZENLhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:37:39 -0400
Message-ID: <4A0C027F.8070806@in.ibm.com>
Date: Thu, 14 May 2009 17:07:35 +0530
From: "B. N. Poornima" <poornima@in.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix potential Divide by Zero error in ext2_get_inode()
References: <4A0A82ED.2040906@in.ibm.com> <20090513150425.89ac9b1c.akpm@linux-foundation.org>
In-Reply-To: <20090513150425.89ac9b1c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 13 May 2009 13:51:01 +0530
> "B. N. Poornima" <poornima@in.ibm.com> wrote:
>
>   
>> Found a line of code in ext2_get_inode function of inode.c in the ext2 
>> filesystem that has the potential of hitting the divide by 0 error.
>> *************************************************
>>  block_group = (ino - 1) / EXT2_INODES_PER_GROUP(sb);
>> *************************************************
>> There is no checking done here to verify if EXT2_INODES_PER_GROUP() 
>> returns 0. This could result in divide by zero error and panic the system.
>> Below is the patch, built against 2.6.30-rc5,  to correct the same:
>>     
>
> EXT2_INODES_PER_GROUP() cannot return zero.  See ext2_fill_super():
>
> 	if (sbi->s_inodes_per_block == 0 || sbi->s_inodes_per_group == 0)
> 		goto cantfind_ext2;
>
>   
Andrew,
Thanks for pointing that out!

Regards,
Poornima.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1767100AbXDTNc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767100AbXDTNc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767103AbXDTNc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:32:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:6299 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767100AbXDTNcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=f3T9iHiwuVFvb+MNY6b99npTUXFEggabtRD0uaFd0xE1etN4eKdUJWBdrITvXPjW8m6XQb/EA5Sbi2cU/yx195bAPdFhU0SAp1nXb+mnfo0HJFHc2VDy9jLx65xsEyfyMzI6p2timmImb6TQ9NZksB4hW5OwEpzdVBigHJ6yqL8=
Message-ID: <6278d2220704200632p3300a6e2y8c9d14f4d735015c@mail.gmail.com>
Date: Fri, 20 Apr 2007 14:32:41 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: bhuvan.mittal@st.com
Subject: Re: How to make mmap'ed kernel buffer non-cacheable
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Apr, 14:20, Bhuvan Kumar MITTAL <bhuvan.mit...@st.com> wrote:
> Hi,
>   I am working on an audio device driver development on Linux. I have a kernel
> buffer which I have mapped to user space using mmap call from user space. My
> problem is that the data which comes to the kernel buffer is getting dropped in
> user space and I get only 50-60% of the data which is randomly ordered. The user
> to kernel level buffer address translation code is fine and I suspect this data
> dropping is occurring coz the kernel buffer is cacheable. Please suggest me some
> way of making the entire buffer non cacheable. I am stuck on this for quite a while
> now.

You can use rdmsr() in your driver to check if the page attribute
table MSR is available, then find and/or add the right entry in the
table to set in each page's flags. This is documented in the Intel
IA-32 Intel Architecture Software Developer's Manuals at intel.com.

Dan
-- 
Daniel J Blueman

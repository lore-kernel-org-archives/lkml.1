Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700Ab0A3RSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700Ab0A3RSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 12:18:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745Ab0A3RSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 12:18:13 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:32771 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0A3RSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 12:18:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=uAD3LlIDVdG5aniuVubawWzwhZChnyY2HbGyJqgNMFgTbpcYAZxT2OxwVnt8l+FvT3
         f4dymKBFxPWNjk2Jf8sRb5wD7oHfMT5KkZq3PeBK9L4I5XzuPfE1pSGPMGq0oR5C9unW
         auK7AjR7McpoHhwo/2hDCQhTHVRTqUXWKH42g=
Date: Sat, 30 Jan 2010 18:18:04 +0100
From: Borislav Petkov <petkovbb@googlemail.com>
To: zhiyi <zhuang@cs.otago.ac.nz>
Cc: linux-kernel@vger.kernel.org, Zhiyi Huang <hzy@cs.otago.ac.nz>
Subject: Re: nr_cpu_ids incorrect on AMD Quad-Core Opteron 8380
Message-ID: <20100130171804.GA2348@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	zhiyi <zhuang@cs.otago.ac.nz>, linux-kernel@vger.kernel.org,
	Zhiyi Huang <hzy@cs.otago.ac.nz>
References: <A1D71FDC-3176-4792-83ED-3ACAA3D61CFF@cs.otago.ac.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A1D71FDC-3176-4792-83ED-3ACAA3D61CFF@cs.otago.ac.nz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 12:16:44PM +1300, zhiyi wrote:
> Hi,
> I have just found the value of nr_cpu_ids is 32, instead of 16 on my
> new Dell PowerEdge R905 which has 16 cpus (4 quad-core Opteron
> 8380). However, /proc/cpuinfo displays the right number (16).
> I have searched the archive but found no related subject.  Is there
> any patch already available to fix the problem?
> I am using 2.6.31-4 and verified this incorrect value (32) using a
> module.

nr_cpu_ids is set to CONFIG_NR_CPUS on SMP kernels and denotes the max
CPUs supported by your kernel. This is not a bug but a configurable
option in the kernel for saving memory.

You can still set CONFIG_NR_CPUS in "-> Processor type and features" to
the max number of cores N you have on your machine if you want to save
approx 8*N KB. But guessing from your quadsocket configuration, memory
shouldn't be that scarce on that machine to go the trouble :).

-- 
Regards/Gruss,
    Boris.

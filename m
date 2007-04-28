Return-Path: <linux-kernel-owner+w=401wt.eu-S1756380AbXD1QZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756380AbXD1QZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 12:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756378AbXD1QZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 12:25:41 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:1765 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756379AbXD1QYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 12:24:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=UJKkT1zCO1z1Zd7uOeGAysTmpOFkodhMaOcslHH/k2yCQqgyj9ZGtDXYnb2NeHKw4QMzMYfhNpUNn11XlwENtgCOWRMhdYjPFRuyICfhjDlfqexv4aXerdDv6/f8s8I+RzR/nBn+807goWxn+jd2c/PPZEQVhO2AGeKWBkyAh5o=
Date: Sun, 29 Apr 2007 01:18:56 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] hugetlbfs: fix error path in module_init
Message-ID: <20070428161856.GA9662@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	William Lee Irwin III <wli@holomorphy.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20070428071923.GB9545@APFDCB5C> <20070428145039.GX19966@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428145039.GX19966@holomorphy.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 07:50:39AM -0700, William Lee Irwin III wrote:
> On Sat, Apr 28, 2007 at 04:19:23PM +0900, Akinobu Mita wrote:
> > init_hugetlbfs_fs() needs to unregister hugetlbfs
> > when kern_mount() returns error.
> > Cc: William Irwin <wli@holomorphy.com>
> > Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> 
> This patch resolves a clear failure to error check.

I reconsider this patch. It was wrong. Because it is overkill to
unregister filesystem just for hugetlbfs_vfsmount mount failure.
Because hugetlbfs_vfsmount is only used for shumget() system call
and also there is some race condition between register_filesystem()
and unregister_filesystem(). (it's not likely happen though)

So what we can do for hugetlbfs module_init failure is
adding NULL check for hugetlbfs_vfsmount in hugetlb_zero_setup().


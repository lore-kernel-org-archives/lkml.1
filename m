Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbYAJBGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbYAJBGL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 20:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYAJBF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 20:05:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbYAJBF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 20:05:57 -0500
Date: Wed, 9 Jan 2008 20:05:31 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Horms <horms@verge.net.au>, magnus.damn@gmail.com
Subject: Re: [PATCH -mm 2/2] kexec/i386: kexec page table code clean up -
	page table setup in C
Message-ID: <20080110010531.GA23143@redhat.com>
References: <1199847470.8126.16.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199847470.8126.16.camel@caritas-dev.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 10:57:50AM +0800, Huang, Ying wrote:
> This patch transforms the kexec page tables setup code from asseumbler
> code to iC code in machine_kexec_prepare. This improves readability and
> reduces code line number.
> 

I think this will create issues for Xen. Initially page table setup
was in C but Xen Guests could not modify the page tables. I think Xen
folks implemented a hypercall where they passed all the page table pages
and the control pages and then hypervisor executed the control page(which
in turn setup the page tables). I think that's why page table setup
code is on the control page in assembly.

You might want to go through Xen kexec implementation and dig through
kexec mailing list archive.

CCing Magnus and Horms. They had done the page tables related changes
for Xen.

Thanks
Vivek

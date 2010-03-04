Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122Ab0CDOtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 09:49:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab0CDOtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 09:49:10 -0500
Date: Thu, 4 Mar 2010 11:42:55 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/18][RFC] Nested Paging support for Nested SVM (aka
 NPT-Virtualization)
Message-ID: <20100304144255.GA26657@amt.cnet>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 08:12:03PM +0100, Joerg Roedel wrote:
> Hi,
> 
> here are the patches that implement nested paging support for nested
> svm. They are somewhat intrusive to the soft-mmu so I post them as RFC
> in the first round to get feedback about the general direction of the
> changes.  Nevertheless I am proud to report that with these patches the
> famous kernel-compile benchmark runs only 4% slower in the l2 guest as
> in the l1 guest when l2 is single-processor. With SMP guests the
> situation is very different. The more vcpus the guest has the more is
> the performance drop from l1 to l2. 
> Anyway, this post is to get feedback about the overall concept of these
> patches.  Please review and give feedback :-)

Joerg,

What perf gain does this bring ? (i'm not aware of the current
overhead).

Overall comments:

Can't you translate l2_gpa -> l1_gpa walking the current l1 nested
pagetable, and pass that to the kvm tdp fault path (with the correct
context setup)?

You probably need to include a flag in base_role to differentiate
between l1 / l2 shadow tables (say if they use the same cr3 value).


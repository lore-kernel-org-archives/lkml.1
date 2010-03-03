Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab0CCXo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:44:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46058 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab0CCXov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:44:51 -0500
Subject: Re: [PATCH 0/18][RFC] Nested Paging support for Nested SVM (aka NPT-Virtualization)
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
Date: Thu, 4 Mar 2010 00:44:48 +0100
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1282BA89-D8EB-499B-BC49-E50CA64E408D@suse.de>
References: <1267643541-451-1-git-send-email-joerg.roedel@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 03.03.2010, at 20:12, Joerg Roedel wrote:

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

Nice job! It's great to see you finally got around to it :-).

Have you tracked what slows down SMP l2 guests yet? So far I've been assuming that IPIs just completely kill the performance, but I guess it shouldn't be that bad, especially now where you have sped up the #VMEXIT path that much.


Alex
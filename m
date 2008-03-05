Return-Path: <linux-kernel-owner+w=401wt.eu-S1762280AbYCEGPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762280AbYCEGPn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 01:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbYCEGPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 01:15:34 -0500
Received: from smtp-out.google.com ([216.239.33.17]:16503 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbYCEGPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 01:15:33 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=OsuTg6USxu0RgSy84cjM+lnW1Q4A97WPwvWhIa4JWq0BwcSvZX7PXJEtxzpr68Ugs
	0eCSvDml5OoSSqnq8YXjg==
Message-ID: <6599ad830803042215n6aedb3eeub0c037e6a4e7bb34@mail.gmail.com>
Date: Tue, 4 Mar 2008 22:15:20 -0800
From: "Paul Menage" <menage@google.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: [RFC] libcg: design and plans
Cc: fedora-devel-list@redhat.com, opensuse-packaging@opensuse.org,
       lkml <linux-kernel@vger.kernel.org>,
       containers@lists.linux-foundation.org,
       "Balbir Singh" <balbir@in.ibm.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Sudhir Kumar" <skumar@linux.vnet.ibm.com>
In-Reply-To: <20080304152341.GB5659@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080304152341.GB5659@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dhaval,

On Tue, Mar 4, 2008 at 7:23 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> Hi,
>
>  We have been working on a library for control groups which would provide
>  simple APIs for programmers to utilize from userspace and make use of
>  control groups.
>
>  We are still designing the library and the APIs. I've attached the
>  design (as of now) to get some feedback from the community whether we
>  are heading in the correct direction and what else should be addressed.

There are a few things that it would be nice to include in such a
library, if you're going to develop one:

- the ability to create abstract groups of processes, and resource
groups, and have the ability to tie these together arbitrarily. E.g
you might create abstract groups A, B and C, and be able to say that A
and B share memory with each other but not with C, and all three
groups are isolated from each other for CPU. Then libcg would mount
different resource types in different cgroup hierarchies (you would
probably tell it ahead of time which combinations of sharing you would
want, in order that it could minimize the number of mounted
hierarchies). When you tell libcg to move a process into abstract
group A, it would move it into the appropriate resource group in each
hierarchy.

- an interface for gathering usage stats from cgroups.

- support for dynamically migrating processes between groups based on
process connector events (i.e. a finished version of the daemon that
you were working on last year)

Paul

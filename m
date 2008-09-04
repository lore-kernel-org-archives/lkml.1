Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbYIDXEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbYIDXEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 19:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754039AbYIDXDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 19:03:53 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44685 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541AbYIDXDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 19:03:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=YYppox1JY4C2xlzahfUOFVvGhznDx4WjPf5JrdS4JUVaPgKOhv7Xl05YPc+ktTb0k
	3XWMud7erMSGrpuS1ET0g==
Message-ID: <6599ad830809041603t320a15eakdfbc6fcab232aa59@mail.gmail.com>
Date: Thu, 4 Sep 2008 16:03:43 -0700
From: "Paul Menage" <menage@google.com>
To: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>
Subject: Re: Default values for cpuset.mems, cpus for children created
Cc: pj@sgi.com, danms@us.ibm.com, "Balbir Singh" <balbir@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       libcg-devel <libcg-devel@lists.sourceforge.net>
In-Reply-To: <20080815193132.GE11844@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080815193132.GE11844@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2008 at 12:31 PM, Dhaval Giani
<dhaval@linux.vnet.ibm.com> wrote:
> Now an application programmer does not really care where and how
> subsystems are mounted (or at least that is what libcgroup aims to
> achieve :-) ). And such a scenario when the cpuset has not been handled
> is going to lead to failures which a user is not expecting.
>
> To work around this, I am making a change which will just set the values
> which the parent group has for unfilled values, but I can already see
> cpuset breaking that assumption as well. (for example exclusive
> cpusets).

Yes, this is an awkwardness with the cpusets model of recursively
sharing a set of identifiable resources. Quite apart from the
backwards compatibility issue, if you make new cpusets inherit their
parent's resources you break the exclusive setting, and if you don't
you require special setup before the cgroup can be used.

There's already a precedent in the cpuset_clone() function, which does
inherit the parent's resources, but I don't think the clone behaviour
is widely used, and even that doesn't handle the case of exclusive
siblings.

I'm inclined to say that this is a userspace bug - if you don't want
cpusets attached to your cgroup hierarchy, don't include them in the
set of mounted subsystems.

Paul

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757767AbYC1SVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767AbYC1SVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755336AbYC1SVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:21:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:35909 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900AbYC1SVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:21:22 -0400
Subject: Re: Trying to make use of hotplug memory for xen balloon driver
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <47EC1E75.6090102@goop.org>
References: <47EAD83A.2000000@goop.org>
	 <1206577595.7883.26.camel@nimitz.home.sr71.net> <47EC1E75.6090102@goop.org>
Content-Type: text/plain
Date: Fri, 28 Mar 2008 11:21:16 -0700
Message-Id: <1206728476.7883.133.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 15:23 -0700, Jeremy Fitzhardinge wrote:
> If the user does a mass online via /sys the system explodes because it
> onlines a large number of pages which have no backing memory.  Since 
> none of those pages can be mapped, the kernel explodes in a variety of
> interesting ways.

Yeah, it does look like you need some kind of partial onlining.

> So I'd really like to inhibit the sysfs interface on these sections.  
> Thoughts?

The balloon driver isn't an exact fit for memory hotplug as it stands,
so there are going to be a few growing pains here. :)

I'm not sure just inhibiting sysfs is the best thing.  What would you
think about adding partial sections, initializing the 'struct page's,
but just not touching the memory?

-- Dave


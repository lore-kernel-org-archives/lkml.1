Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbYFKKn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbYFKKn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 06:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbYFKKnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 06:43:22 -0400
Received: from as1.cineca.com ([130.186.84.213]:35007 "EHLO as1.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbYFKKnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 06:43:21 -0400
Message-ID: <484FAC37.90300@gmail.com>
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.12) Gecko/20070604 Thunderbird/1.5.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
Subject: Re: [RFC PATCH 3/5] mgmcg VM overcommit interface
References: <>  <1213054383-18137-4-git-send-email-righi.andrea@gmail.com> <1213119746.13882.15.camel@nimitz>
In-Reply-To: <1213119746.13882.15.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 11 Jun 2008 12:43:03 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Tue, 2008-06-10 at 01:33 +0200, Andrea Righi wrote:
>> +       cgroup_unlock();
>> +
>> +       count = sprintf(page, "CommitLimit:  %8lu kB\n"
>> +                             "Committed_AS: %8lu kB\n",
>> +                             K(allowed), K(committed));
>> +       ret = simple_read_from_buffer(userbuf, nbytes, ppos, page, count);
>> +out:
>> +       free_page((unsigned long)page);
>> +       return ret;
>> +}
> 
> I know you're trying to make this look like meminfo, but it does butcher
> the sysfs rules a bit.  How about breaking it out into a couple of
> files?
> 
> -- Dave

Sounds reasonable.

Anyway, I think this patchset should be simply dropped in favor of the
Balbir's memrlimit controller, as reported by Kamezawa.

The memrlimit controller permits to implement the overcommit policies in
userspace directly setting the cgroup VM limits (well.. I've not read the
memrlimit source yet, but from the documentation it seems so).

-Andrea

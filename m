Return-Path: <linux-kernel-owner+w=401wt.eu-S1030651AbXCLQsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030651AbXCLQsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 12:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030653AbXCLQsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 12:48:11 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49020 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030651AbXCLQsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 12:48:10 -0400
Subject: Re: [RFC][PATCH 3/7] Data structures changes for RSS accounting
From: Dave Hansen <hansendc@us.ibm.com>
To: Kirill Korotaev <dev@sw.ru>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@sw.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <45F57CFB.9010707@sw.ru>
References: <45ED7DEC.7010403@sw.ru> <45ED8181.2060905@sw.ru>
	 <m18xe3wq3t.fsf@ebiederm.dsl.xmission.com>  <45F57CFB.9010707@sw.ru>
Content-Type: text/plain
Date: Mon, 12 Mar 2007 09:48:04 -0700
Message-Id: <1173718084.11945.51.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-12 at 19:16 +0300, Kirill Korotaev wrote:
> now VE2 maps the same page. You can't determine whether this page is mapped
> to this container or another one w/o page->container pointer. 

Hi Kirill,

I thought we can always get from the page to the VMA.  rmap provides
this to us via page->mapping and the 'struct address_space' or anon_vma.
Do we agree on that?

We can also get from the vma to the mm very easily, via vma->vm_mm,
right?

We can also get from a task to the container quite easily.  

So, the only question becomes whether there is a 1:1 relationship
between mm_structs and containers.  Does each mm_struct belong to one
and only one container?  Basically, can a threaded process have
different threads in different containers?

It seems that we could bridge the gap pretty easily by either assigning
each mm_struct to a container directly, or putting some kind of
task-to-mm lookup.  Perhaps just a list like
mm->tasks_using_this_mm_list.

Not rocket science, right?

-- Dave


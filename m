Return-Path: <linux-kernel-owner+w=401wt.eu-S1756835AbZF2VXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbZF2VXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 17:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZF2VXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 17:23:39 -0400
Received: from claw.goop.org ([74.207.240.146]:52941 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752513AbZF2VXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 17:23:38 -0400
Message-ID: <4A4930DA.5030700@goop.org>
Date: Mon, 29 Jun 2009 14:23:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
       xen-devel@lists.xensource.com, npiggin@suse.de, chris.mason@oracle.com,
       kurt.hackel@oracle.com, dave.mccracken@oracle.com,
       Avi Kivity <avi@redhat.com>, Rik van Riel <riel@redhat.com>,
       alan@lxorguk.ukuu.org.uk, Rusty Russell <rusty@rustcorp.com.au>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, akpm@osdl.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, tmem-devel@oss.oracle.com,
       sunil.mushran@oracle.com, linux-mm@kvack.org,
       Himanshu Raj <rhim@microsoft.com>
Subject: Re: [RFC] transcendent memory for Linux
References: <6639b922-4ed7-48fd-9a3d-c78a4f93355c@default>
In-Reply-To: <6639b922-4ed7-48fd-9a3d-c78a4f93355c@default>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/09 14:13, Dan Magenheimer wrote:
> The uuid is only used for shared pools.  If two different
> "tmem clients" (guests) agree on a 128-bit "shared secret",
> they can share a tmem pool.  For ocfs2, the 128-bit uuid in
> the on-disk superblock is used for this purpose to implement
> shared precache.  (Pages evicted by one cluster node
> can be used by another cluster node that co-resides on
> the same physical system.)
>   

What are the implications of some third party VM guessing the "uuid" of
a shared pool?  Presumably they could view and modify the contents of
the pool.  Is there any security model beyond making UUIDs unguessable?

> The (page)size argument is always fixed (at PAGE_SIZE) for
> any given kernel.  The underlying implementation can
> be capable of supporting multiple pagesizes.
>   

Pavel's other point was that merging the size field into the flags is a
bit unusual/ugly.  But you can workaround that by just defining the
"flag" values for each plausible page size, since there's a pretty small
bound: TMEM_PAGESZ_4K, 8K, etc.

Also, having an "API version number" is a very bad idea.  Such version
numbers are very inflexible and basically don't work (esp if you're
expecting to have multiple independent implementations of this API). 
Much better is to have feature flags; the caller asks for features on
the new pool, and pool creation either succeeds or doesn't (a call to
return the set of supported features is a good compliment).

    J

Return-Path: <linux-kernel-owner+w=401wt.eu-S932985AbXCRWoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbXCRWoc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 18:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933388AbXCRWoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 18:44:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:50124 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932985AbXCRWob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 18:44:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=b2lHYvCEqde4d7/pD2IqI9IcvjsW9ehXS9jBo8MAxiFx2sXVVPKHZtdINZWpdvWZ/
	/q6bFrdsWopGpzeeiEXTA==
Message-ID: <6599ad830703181544g52f25820rff1c87e462b8f1d4@mail.gmail.com>
Date: Sun, 18 Mar 2007 15:44:24 -0700
From: "Paul Menage" <menage@google.com>
To: "Dave Hansen" <hansendc@us.ibm.com>
Subject: Re: [Devel] Re: [RFC][PATCH 2/7] RSS controller core
Cc: "Andrew Morton" <akpm@linux-foundation.org>, containers@lists.osdl.org,
       "Mel Gorman" <MELGOR@ie.ibm.com>, linux-kernel@vger.kernel.org,
       "Andy Wihitcroft" <apw@shadowen.org>
In-Reply-To: <1173805534.6680.26.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45ED7DEC.7010403@sw.ru> <45F3F581.9030503@sw.ru>
	 <20070311045111.62d3e9f9.akpm@linux-foundation.org>
	 <20070312010039.GC21861@MAIL.13thfloor.at>
	 <1173724979.11945.103.camel@localhost.localdomain>
	 <20070312224129.GC21258@MAIL.13thfloor.at>
	 <20070312220439.677b4787.akpm@linux-foundation.org>
	 <45F67AC9.4080707@sw.ru>
	 <20070313034834.14013bb0.akpm@linux-foundation.org>
	 <1173805534.6680.26.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, Dave Hansen <hansendc@us.ibm.com> wrote:
> How do we determine what is shared, and goes into the shared zones?
> Once we've allocated a page, it's too late because we already picked.
> Do we just assume all page cache is shared?  Base it on filesystem,
> mount, ...?  Mount seems the most logical to me, that a sysadmin would
> have to set up a container's fs, anyway, and will likely be doing
> special things to shared data, anyway (r/o bind mounts :).

I played with an approach where you can bind a dentry to a set of
memory zones, and any children of that dentry would inherit the
mempolicy; I was envisaging that most data wouldn't be shared between
different containers/jobs, and that userspace would set up "shared"
zones for big shared regions such as /lib, /usr, /bin, and for
specially-known cases of sharing.

> If we really do bind a set of processes strongly to a set of memory on a
> set of nodes, then those really do become its home NUMA nodes.  If the
> CPUs there get overloaded, running it elsewhere will continue to grab
> pages from the home.  Would this basically keep us from ever being able
> to move tasks around a NUMA system?

move_pages() will let you shuffle tasks from one node to another
without too much intrusion.

Paul

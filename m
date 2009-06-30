Return-Path: <linux-kernel-owner+w=401wt.eu-S1757168AbZF3WrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168AbZF3WrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:47:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755130AbZF3Wqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:46:48 -0400
Received: from claw.goop.org ([74.207.240.146]:51622 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbZF3Wqs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:46:48 -0400
Message-ID: <4A4A95D8.6020708@goop.org>
Date: Tue, 30 Jun 2009 15:46:48 -0700
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
       Himanshu Raj <rhim@microsoft.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>
Subject: Re: [RFC] transcendent memory for Linux
References: <c31ca108-9b68-40ba-936f-3ed2a56fd90b@default>
In-Reply-To: <c31ca108-9b68-40ba-936f-3ed2a56fd90b@default>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/09 14:21, Dan Magenheimer wrote:
> No, the uuid can't be verified.  Tmem gives no indication
> as to whether a newly-created pool is already in use (shared)
> by another guest.  So without both the 128-bit uuid and an
> already-in-use 64-bit object id and 32-bit page index, no data
> is readable or writable by the attacker.
>   

You have to consider things like timing attacks as well (for example, a
tmem hypercall might return faster if the uuid already exists).

Besides, you can tell whether a uuid exists, by at least a couple of
mechanisms (from a quick read of the source, so I might have overlooked
something):

   1. You can create new shared pools until it starts failing as a
      result of hitting the MAX_GLOBAL_SHARED_POOLS limit with junk
      uuids.  If you then successfully "create" a shared pool while
      searching, you know it already existed.
   2. The returned pool id will increase unless the pool already exists,
      in which case you'll get a smaller id back (ignoring wraparound).


> Hmmm... that is definitely a thornier problem.  I guess the
> security angle definitely deserves more design.  But, again,
> this affects only shared precache which is not intended
> to part of the proposed initial tmem patchset, so this is a futures
> issue.)

Yeah, a shared namespace of accessible objects is an entirely new thing
in the Xen universe.  I would also drop Xen support until there's a good
security story about how they can be used.

    J


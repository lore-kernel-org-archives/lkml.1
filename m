Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbZGGTys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbZGGTys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 15:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbZGGTyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 15:54:40 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:19729 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbZGGTyj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 15:54:39 -0400
MIME-Version: 1.0
Message-ID: <92d23660-c8a3-4107-aee6-ec251ff65b99@default>
Date: Tue, 7 Jul 2009 12:53:06 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de, akpm@osdl.org,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
       kurt.hackel@oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       dave.mccracken@oracle.com, Marcelo Tosatti <mtosatti@redhat.com>,
       sunil.mushran@oracle.com, Avi Kivity <avi@redhat.com>,
       Schwidefsky <schwidefsky@de.ibm.com>, chris.mason@oracle.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: RE: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
In-Reply-To: <4A5385AD.9000800@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.2  (306040) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: abhmt006.oracle.com [141.146.116.15]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4A53A7D1.01E5:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rik van Riel [mailto:riel@redhat.com]

> Dan Magenheimer wrote:
> > "Preswap" IS persistent, but for various reasons may not always be
> > available for use, again due to factors that may not be 
> visible to the
> > kernel (but, briefly, if the kernel is being "good" and has 
> shared its
> > resources nicely, then it will be able to use preswap, else 
> it will not).
> > Once a page is put, a get on the page will always succeed. 
> 
> What happens when all of the free memory on a system
> has been consumed by preswap by a few guests?
> Will the system be unable to start another guest,

The default policy (and only policy implemented as of now) is
that no guest is allowed to use more than max_mem for the
sum of directly-addressable memory (e.g. RAM) and persistent
tmem (e.g. preswap).  So if a guest is using its default
memory==max_mem and is doing no ballooning, nothing can
be put in preswap by that guest.
 
> or is there some way to free the preswap memory?

Yes and no.  There is no way externally to free preswap
memory, but an in-guest userland root service can write to sysfs
to affect preswap size.  This essentially does a partial
swapoff on preswap if there is sufficient (directly addressable)
guest RAM available.  (I have this prototyped as part of
the xenballoond self-ballooning service in xen-unstable.)

Dan

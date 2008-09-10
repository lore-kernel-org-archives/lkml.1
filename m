Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbYIJH0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbYIJH0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 03:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYIJH0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 03:26:47 -0400
Received: from wx-out-0506.google.com ([66.249.82.227]:3006 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbYIJH0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 03:26:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=MVldrGAtAsOez+zA4vWrSGWPLw+9QGasquBXlu9tAQDAtayA0wWeEAxphdpmBtaXQn
         WQwXcfxOQ6OwKb9uVbSRzNgd+6E81PuFljJ3ENrx2KiqApCmVqhZML53NzTR1q3J6WkT
         tk2mF50D1NakcCDM1Ji57Ydq848nM2hkn5tO8=
Message-ID: <48C776B0.9070703@gmail.com>
Date: Wed, 10 Sep 2008 09:26:40 +0200
From: Andrea Righi <righi.andrea@gmail.com>
Reply-To: righi.andrea@gmail.com
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       David Radford <dradford@bluehost.com>,
       Marco Innocenti <m.innocenti@cineca.it>,
       =?ISO-8859-1?Q?Fernando_Luis_?= =?ISO-8859-1?Q?V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>,
       containers@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Carl Henrik Lunde <chlunde@ping.uio.no>, linux-mm@kvack.org,
       Divyesh Shah <dpshah@google.com>, Matt Heaton <matt@bluehost.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Naveen Gupta <ngupta@google.com>
Subject: Re: [RFC] [PATCH -mm] cgroup: limit the amount of dirty file pages
References: <48C6987D.2050905@gmail.com> <1220982584.23386.219.camel@nimitz>
In-Reply-To: <1220982584.23386.219.camel@nimitz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Tue, 2008-09-09 at 17:38 +0200, Andrea Righi wrote:
>> It allows to control how much dirty file pages a cgroup can have at any
>> given time. This feature is supposed to be strictly connected to a
>> generic cgroup IO controller (see below).
> 
> So, this functions similarly to our global dirty ratio?  Is it just
> intended to keep a cgroup from wedging itself too hard with too many
> dirty pages, just like the global ratio?
> 
> -- Dave

Correct, it's the same functionality provided by vm.dirty_ratio and
vm.dirty_background_ratio, except that is intended to be per-cgroup.

Without this functionality, a cgroup can even dirty all its memory,
allocated by the memory controller, since statistics and writeback
configurations are global.

-Andrea

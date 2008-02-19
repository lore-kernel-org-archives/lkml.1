Return-Path: <linux-kernel-owner+w=401wt.eu-S1760389AbYBSV55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760389AbYBSV55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 16:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYBSV5t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 16:57:49 -0500
Received: from relay2.sgi.com ([192.48.171.30]:35685 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753863AbYBSV5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 16:57:48 -0500
Date: Tue, 19 Feb 2008 15:57:42 -0600
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: menage@google.com, balbir@linux.vnet.ibm.com, balbir@in.ibm.com,
       xemul@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 1/7] CGroup API: Add cgroup.api control file
Message-Id: <20080219155742.0298f25f.pj@sgi.com>
In-Reply-To: <47B953A8.9030206@cn.fujitsu.com>
References: <20080215204418.535025000@menage.corp.google.com>
	<20080215204820.734926000@menage.corp.google.com>
	<47B6B5CA.7040201@linux.vnet.ibm.com>
	<6599ad830802160944v6d529570k1ade6df273ca3d0d@mail.gmail.com>
	<47B953A8.9030206@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> It seems to me this is a little messy.

Agreed.  It looks too finicky to base real software on;  that is, I
doubt that any robust application or user level software is going to
depend on it for serious automated self-configuration.

I haven't seen a serious problem with cpuset documentation, which is
the earlier API of this flavor (though, granted, I'd be the last
person on the planet to see such ;).  It seems to me that this style
of API is easy enough for a variety of people to figure out that this
won't help that much.  And certainly the more interesting details that
need documentation are far too verbose for this presentation.

So ... little or no programmatic use, little or no human use.

It also reminds me a bit, in a very loose way, of efforts in sysfs that
have taken us a while, and too many changes, to get right.  One needs to
be -selective- in what one exposes, in order to minimize maintenance costs
and maximize the signal-to-noise ratio, over time.  This feels like it
exposes too much.

Finally, it goes against the one thingie per file (at most, one scalar
vector) that has worked well for us when tried.

As to the motivations Paul M gives:
 1) Avoid "an arbitrary mess of ad-hoc APIs":
	We can still do that, whether or not we "self-document" these
	API's in this manner.
 2) binary APIs versus ASCII APIs:
	Well, I have an ASCII API bias, not surprising.  But I'd
	suggest not doing things "in anticipation" of some future
	fuzzy binary API support.  Wait until that day actually arrives.
 3) The memory controller currently has files with the "_in_bytes":
	The traditional way to handle this is Documentation and man
	pages; good enough for my granddad, good enough for me ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214

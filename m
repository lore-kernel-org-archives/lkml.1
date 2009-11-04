Return-Path: <linux-kernel-owner+w=401wt.eu-S1758143AbZKDXhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143AbZKDXhv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757241AbZKDXhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:37:51 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:39000 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015AbZKDXhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:37:50 -0500
Date: Wed, 4 Nov 2009 15:37:45 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Paul Menage <menage@google.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jan@smtp1.linux-foundation.org, Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       Safranek <jsafrane@redhat.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
Message-ID: <20091104233745.GB3668@count0.beaverton.ibm.com>
References: <20091104063005.GC3560@balbir.in.ibm.com>
 <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
 <20091104173517.GA3668@count0.beaverton.ibm.com>
 <6599ad830911041325i9b309a7y4d912d6be7ddbdd9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830911041325i9b309a7y4d912d6be7ddbdd9@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 04, 2009 at 01:25:46PM -0800, Paul Menage wrote:
> On Wed, Nov 4, 2009 at 9:35 AM, Matt Helsley <matthltc@us.ibm.com> wrote:
> >
> > If anything, "standardizing" the mount point(s) will likely provide a false
> > sense of uniformity and we'll get some bad userspace scripts/tools that
> > break when "nonstandard" usage appears. Leaving the mount point undefined
> > forces anyone writing scripts or tools to consider whether they want to be
> > portable and, if so, the proper way to find the cgroup hierarchies they need
> > to manipulate.
> 
> Scanning /proc/mounts to find the relevant mount locations is pretty
> simple, for code that's just wanting to use existing cgroup mounts.
> But for the code that sets up mounts in the first place, its probably
> helpful to have recommendations of suitable locations.

If the tool set up the mounts in the first place then there's nothing
gained, as far as the code is concerned, by standardizing the location.
It could just as easily make a temporary directory and put it there.

If it's specified in an /etc file by the user then standardization
gets us nothing but inflexibility. The user knows where it is (they set it)
and the code knows where it is (via /proc OR /etc).

Recommending default locations seems helpful only so that users can inspect
what the code does. Blessing one location as the "standard, one, true location"
for code to use -- via FHS/LSB/whatnot -- seems like asking for trouble.

Cheers,
	-Matt

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbZIYAir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbZIYAir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 20:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZIYAiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 20:38:46 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:62558 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbZIYAip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 20:38:45 -0400
Date: Thu, 24 Sep 2009 20:38:20 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>
Subject: Re: regression in page writeback
Message-ID: <20090925003820.GK2662@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dave Chinner <david@fromorbit.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Li, Shaohua" <shaohua.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"richard@rsk.demon.co.uk" <richard@rsk.demon.co.uk>,
	"jens.axboe@oracle.com" <jens.axboe@oracle.com>
References: <20090922175452.d66400dd.akpm@linux-foundation.org>
 <20090923011758.GC6382@localhost>
 <20090922182832.28e7f73a.akpm@linux-foundation.org>
 <20090923014500.GA11076@localhost>
 <20090922185941.1118e011.akpm@linux-foundation.org>
 <20090923022622.GB11918@localhost>
 <20090922193622.42c00012.akpm@linux-foundation.org>
 <20090923140058.GA2794@think>
 <20090924031508.GD6456@localhost>
 <20090925001117.GA9464@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925001117.GA9464@discord.disaster>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: abhmt004.oracle.com [141.146.116.13]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4ABC1102.002E:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 10:11:17AM +1000, Dave Chinner wrote:
> On Thu, Sep 24, 2009 at 11:15:08AM +0800, Wu Fengguang wrote:
> > On Wed, Sep 23, 2009 at 10:00:58PM +0800, Chris Mason wrote:
> > > The only place that actually honors the congestion flag is pdflush.
> > > It's trivial to get pdflush backed up and make it sit down without
> > > making any progress because once the queue congests, pdflush goes away.
> > 
> > Right. I guess that's more or less intentional - to give lowest priority
> > to periodic/background writeback.
> 
> IMO, this is the wrong design. Background writeback should
> have higher CPU/scheduler priority than normal tasks. If there is
> sufficient dirty pages in the system for background writeback to
> be active, it should be running *now* to start as much IO as it can
> without being held up by other, lower priority tasks.

I'd say that an fsync from mutt or vi should be done at a higher prio
than a background streaming writer.

-chris

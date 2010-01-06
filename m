Return-Path: <linux-kernel-owner+w=401wt.eu-S932586Ab0AFSj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab0AFSj4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 13:39:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932254Ab0AFSj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 13:39:56 -0500
Received: from mga10.intel.com ([192.55.52.92]:41312 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932230Ab0AFSjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 13:39:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,230,1262592000"; 
   d="scan'208";a="761894993"
Date: Wed, 6 Jan 2010 10:39:48 -0800
From: mark gross <mgross@linux.intel.com>
To: Daniel Walker <dwalker@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, davidb@quicinc.com, pchidamb@quicinc.com
Subject: Re: [PATCH] pm_qos: Add QoS param, minimum system bus frequency
Message-ID: <20100106183948.GA21316@linux.intel.com>
Reply-To: mgross@linux.intel.com
References: <1262308827-24215-1-git-send-email-dwalker@codeaurora.org>
 <20100104213852.GA5031@linux.intel.com>
 <1262642445.3097.11.camel@c-dwalke-linux.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262642445.3097.11.camel@c-dwalke-linux.qualcomm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 02:00:45PM -0800, Daniel Walker wrote:
> On Mon, 2010-01-04 at 13:38 -0800, mark gross wrote:
> > On Thu, Dec 31, 2009 at 05:20:27PM -0800, Daniel Walker wrote:
> > > From: Praveen Chidambaram <pchidamb@quicinc.com>
> > > 
> > > In some systems, the system bus speed can be varied, usually
> > > based on the current CPU frequency.  However, various device
> > > drivers and/or applications may need a faster system bus for I/O
> > > even though the CPU itself may be idle
> > 
> > What happened to the discussion around multiple platforms needing
> > multiple bus pm_qos_requirements?  
> > 
> > Is system bus freq too generic? (I'm worried about the name space)
> > Is this ok? (I'm asking linux-pm for input here.)
> > On X86 would this be analogous to FSB, Memory, or PCI bus frequencies?
> > What will happen when there are two buses each wanting a PM_QOS
> > parameter?  Is that a likely scenario?
> 
> We can always change the naming in the future, but someone could add a
> PM_QOS_MEMORY_BUS_FREQ or PM_QOS_PERIPHERAL_BUS_FREQ in addition to this
> one.. Since it's all generic code having generic naming seems fine..
> 
> > Also, on your platform you have a throttling driver controlling the
> > frequency of some bus, that will use this value as a constraint on how
> > far it will throttle.  no?  I would be interested in seeing this driver
> > sometime.  (I just want to make sure no one bastardizes pm_qos into an
> > operating point thing.  I'm not sure I can justify why but I want to
> > avoid that.)
> 
> When you say "operating point thing" do you mean you don't want the
> frequency adjusted at runtime? You want it set once then move on?
>
no, I mean that I want the parameter to be used to constrain throttling
done by drivers and not define the settings used by the drivers. 

I worry that the parameter could be used as "the setting" to use by the
driver thus pulling the PM throttling logic from the driver and putting
it in user mode as a back door operating point interface.

Its a subtle distinction but its one of the things I worry about.  Also,
I'm not sure I can fight off good arguments for me to lighten up on this
point, but I'll try if it comes to that. ;)

--mgross 

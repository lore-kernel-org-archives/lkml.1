Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZI3OkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZI3OkM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 10:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZI3OkL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 10:40:11 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50570 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbZI3OkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 10:40:09 -0400
Date: Wed, 30 Sep 2009 20:09:53 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Bharata B Rao <bharata@linux.vnet.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Herbert Poetzl <herbert@13thfloor.at>, Avi Kivity <avi@redhat.com>,
       Chris Friesen <cfriesen@nortel.com>, Paul Menage <menage@google.com>,
       Mike Waychison <mikew@google.com>
Subject: Re: [RFC v2 PATCH 0/8] CFS Hard limits - v2
Message-ID: <20090930143953.GA2014@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20090930124919.GA19951@in.ibm.com> <4AC35EDD.1080902@openvz.org> <20090930142537.GJ19951@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090930142537.GJ19951@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 30, 2009 at 07:55:37PM +0530, Bharata B Rao wrote:
> On Wed, Sep 30, 2009 at 05:36:29PM +0400, Pavel Emelyanov wrote:
> > Bharata B Rao wrote:
> > > Hi,
> > > 
> > > Here is the v2 post of hard limits feature for CFS group scheduler. This
> > > RFC post mainly adds runtime borrowing feature and has a new locking scheme
> > > to protect CFS runtime related fields.
> > > 
> > > It would be nice to have some comments on this set!
> > 
> > I have a question I'd like to ask before diving into the code.
> > Consider I'm a user, that has a 4CPUs box 2GHz each and I'd like
> > to create a container with 2CPUs 1GHz each. Can I achieve this
> > after your patches?
> 
> I am not sure if I understand the GHz specification you mention here.
> Are you saying that you want run a container with 2 CPUS with each of
> them running at half their (frequency)capacity ?
> 
> This hard limits scheme is about time based rate limiting where you can
> specify a runtime(=hard limit) and a period for the container and the
> container will not be allowed to consume more than the specified CPU time
> within a given period.

IMO Pavel's requirement can be met with a hard limit of 25%

	2 CPU of 1GHz = (1/2 x 4) (1/2 x 2) GHz CPUs
		      = 1/4 x 4 2GHz CPU
		      = 25% of (4 2GHz CPU)

IOW by hard-limiting a container thread to run just 0.5sec every sec on a 2GHz 
cpu, it is effectively making progress at the rate of 1GHz?

- vatsa

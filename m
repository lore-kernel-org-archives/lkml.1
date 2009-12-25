Return-Path: <linux-kernel-owner+w=401wt.eu-S1753017AbZLYIcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbZLYIcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 03:32:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZLYIcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 03:32:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:49954 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbZLYIcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 03:32:41 -0500
Date: Fri, 25 Dec 2009 09:35:04 +0100
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Smith, GeoffX" <geoffx.smith@intel.com>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Michael Stone <michael@laptop.org>
Subject: Re: [PATCH] prctl: return MCE process flags through pointer
Message-ID: <20091225093504.0c1224a2@infradead.org>
In-Reply-To: <20091223105450.8f15db9f.akpm@linux-foundation.org>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1829@orsmsx510.amr.corp.intel.com>
	<87hbricwz8.fsf@basil.nowhere.org>
	<20091222173424.980d5d33.akpm@linux-foundation.org>
	<20091223095223.GB20539@basil.fritz.box>
	<20091223021807.abbd993e.akpm@linux-foundation.org>
	<354B2877CF17F44BB3FA44EB4DB0E5470C91CE18A8@orsmsx510.amr.corp.intel.com>
	<20091223105450.8f15db9f.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Dec 2009 10:54:50 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 23 Dec 2009 09:56:04 -0800 "Smith, GeoffX"
> <geoffx.smith@intel.com> wrote:
> 
> > >Why are task_struct.timer_slack_ns and
> > >task_struct.default_timer_slack_ns unsigned long, btw?  AFACIT we
> > >could make them unsigned ints.
> > 
> > Timer slack is not a Boolean or enum, and we want the greatest
> > range possible.  (Actually, I'd like to talk Arjan into using the
> > same time structure as select(), but that's another discussion.)
> > Internally hrtimer uses unsigned long.  I know long and unsigned
> > long are the same on some architectures, but let's not introduce an
> > unnatural restriction -- recall that arg2 is unsigned long.
> 
> Using unsigned ints will reduce the size of the task_struct.
> 
> Is there any conceivable case for a timer_slack which exceeds four
> seconds?  

the largest I've seen asked in practice is 2 seconds.
But even at 100 msec or more you're talking about very special
applications; rounding up timers otherwise really impacts the
functionality of the app in a bad way.


> If so, what is it, and if so, why this:
> 
> #define MAX_SLACK       (100 * NSEC_PER_MSEC)

this is the max for "automatic slack"

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org

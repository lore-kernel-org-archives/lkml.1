Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZLWSzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZLWSzI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 13:55:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbZLWSzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 13:55:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41393 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751256AbZLWSzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 13:55:05 -0500
Date: Wed, 23 Dec 2009 10:54:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Smith, GeoffX" <geoffx.smith@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Michael Stone <michael@laptop.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] prctl: return MCE process flags through pointer
Message-Id: <20091223105450.8f15db9f.akpm@linux-foundation.org>
In-Reply-To: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE18A8@orsmsx510.amr.corp.intel.com>
References: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE1829@orsmsx510.amr.corp.intel.com>
	<87hbricwz8.fsf@basil.nowhere.org>
	<20091222173424.980d5d33.akpm@linux-foundation.org>
	<20091223095223.GB20539@basil.fritz.box>
	<20091223021807.abbd993e.akpm@linux-foundation.org>
	<354B2877CF17F44BB3FA44EB4DB0E5470C91CE18A8@orsmsx510.amr.corp.intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Dec 2009 09:56:04 -0800 "Smith, GeoffX" <geoffx.smith@intel.com> wrote:

> >Why are task_struct.timer_slack_ns and
> >task_struct.default_timer_slack_ns unsigned long, btw?  AFACIT we could
> >make them unsigned ints.
> 
> Timer slack is not a Boolean or enum, and we want the greatest range possible.  (Actually, I'd like to talk Arjan into using the same time structure as select(), but that's another discussion.) Internally hrtimer uses unsigned long.  I know long and unsigned long are the same on some architectures, but let's not introduce an unnatural restriction -- recall that arg2 is unsigned long.

Using unsigned ints will reduce the size of the task_struct.

Is there any conceivable case for a timer_slack which exceeds four
seconds?  If so, what is it, and if so, why this:

#define MAX_SLACK       (100 * NSEC_PER_MSEC)

?

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbYCGKDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbYCGKDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 05:03:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762545AbYCGKDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 05:03:13 -0500
Received: from sacred.ru ([62.205.161.221]:54958 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762290AbYCGKDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 05:03:08 -0500
Message-ID: <47D11068.9010704@openvz.org>
Date: Fri, 07 Mar 2008 12:52:40 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, menage@google.com, sukadev@us.ibm.com,
       serue@us.ibm.com, Greg KH <greg@kroah.com>
Subject: Re: [PATCH 5/9] Make use of permissions, returned by kobj_lookup
References: <47CED717.60406@openvz.org>	<47CEDA64.1070506@openvz.org>	<20080305171304.f686f6de.akpm@linux-foundation.org>	<47D10939.6020806@openvz.org> <20080307013553.7ed35f91.akpm@linux-foundation.org>
In-Reply-To: <20080307013553.7ed35f91.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 07 Mar 2008 12:52:39 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 07 Mar 2008 12:22:01 +0300 Pavel Emelyanov <xemul@openvz.org> wrote:
> 
>>> This doesn't include sufficient headers to be compileable.
>>>
>>> I'm sure there are lots of headers like this.  But we regularly need
>>> to fix them.
>>>
>> Not sure, whether this is still relevant after Greg's comments, but that's
>> the -fix patch for this one. (It will cause a conflict with the 9th patch.)
> 
> Well.  Where do we stand with this?  afaict the state of play is:
> 
> Greg: do it in udev
> Pavel: but people want to run old distros in containers

Actually no.

Greg: Use LSM for this
Pavel: My approach just makes maps per-group, while LSM will
       bring a new level of filtering/lookup on device open path

> Realistically, when is the mainline kernel likely to have sufficient
> container functionality which is sufficiently well-tested for people to
> actually be able to do that?  And how much longer will it take for that
> kernel.org functionality to propagate out into non-bleeding-edge distros?

The fact is that we have users of OpenVZ and even Virtuozzo, that still use 
redhat-9 as in containers. So even if this is ready in 5 years, there will 
always be someone who sets the outdated (by that time) fedora-core-8 and find
out, that his udev refuses to work.

> Altogether we're looking at one to three years, aren't we?  By then,
> perhaps a lot of "old" distros are already udev-based.
> 
> otoh, my experience upgrading old kernels to new udev has not been a
> good one (ie: it didn't work).

Agree, but we're talking about making old udev working with new kernel.

> 


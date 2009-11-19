Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbZKSPA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbZKSPA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 10:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbZKSPA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 10:00:56 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:58999 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbZKSPA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 10:00:56 -0500
MIME-Version: 1.0
In-Reply-To: <20091119144853.GA1398@srcf.ucam.org>
References: <20091118200712.GA14026@srcf.ucam.org> <20091118213355.GA16630@srcf.ucam.org> 
	<ac3eb2510911190309y6d0d8445wd907fc5664595c6f@mail.gmail.com> 
	<20091119130107.GB20949@srcf.ucam.org> <ac3eb2510911190529p6810508fve4941f3077dfd3d9@mail.gmail.com> 
	<20091119141634.GA311@srcf.ucam.org> <ac3eb2510911190625i7432644aod6e99829b8a03dc4@mail.gmail.com> 
	<20091119143008.GA719@srcf.ucam.org> <ac3eb2510911190634m20947c86w78340d22eff290ca@mail.gmail.com> 
	<20091119144853.GA1398@srcf.ucam.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 19 Nov 2009 16:00:46 +0100
Message-ID: <ac3eb2510911190700o6f4e80cm172c14dc0f28451d@mail.gmail.com>
Subject: Re: [PATCH] [RFC] Add support for uevents on block device idle 
	changes
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: David Zeuthen <david@fubar.dk>, linux-kernel@vger.kernel.org,
       axboe@kernel.dk, linux-hotplug@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 19, 2009 at 15:48, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Thu, Nov 19, 2009 at 03:34:53PM +0100, Kay Sievers wrote:
>
>> Single-subscriber event interfaces are usually a no-go for generic
>> infrastructure like this. We still have the unmodified HAL running
>> until it is dead, and this works only because there are no such
>> awkward interfaces. In a few years we will probably have diskfoo
>> replacing dk-disks, and then ... :)
>
> If you've got any ideas for what a multi-subscriber interface would look
> like, I'm happy look at it.

Yeah, it would not be as simple as your patch. It probably involves a
way to get a file descriptor per listener, to let the kernel know if
anybody is interested, and to auto-cleanup when the listener dies, and
to have per instance timers.

> I don't think there's an especially
> compelling use-case for one right now so I'm not enthusiastic about the
> additional complexity that'd be required,

Right, but we've been there, and it's a pain, if you can not subscribe
to an interface because something else is already using it/expecting
it is the only user ever. So there needs to be a good reason for
adding something like this as a new interface, which will very likely
hit us back some day.

> but as long as there's basic
> agreement that it's not practical to do this in userspace then we're at
> least on the same page.

I'm all for executing the policy inside the kernel and let userspace
only enable/configure it. It think there is not much to disagr4ee
about such an approach.

Thanks,
Kay

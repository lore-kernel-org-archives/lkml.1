Return-Path: <linux-kernel-owner+w=401wt.eu-S1753448AbYASJhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbYASJhI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 04:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303AbYASJgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 04:36:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:18252 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbYASJgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 04:36:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ffERsk+QjETidmNW0mhGsMZfDr3nB0EyVu/nqjJBvYbQeB/+0YQQdPx8wGudMAM4iuvNoHOszetSb1vdu9k6okf82jDBa+vdYkPUSwdSz9LVIstb6PuuWIU5AmHj3g8v6KqRq2uJrSu+BPlSy7ymEfCrQu5to8E4W9acaQp6ke8=
Message-ID: <4791C555.9050205@gmail.com>
Date: Sat, 19 Jan 2008 10:39:33 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Icedove 1.5.0.14pre (X11/20071020)
MIME-Version: 1.0
To: Dave Young <hidave.darkstar@gmail.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, stefanr@s5r6.in-berlin.de,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] driver-core : convert semaphore to mutex in struct
 class
References: <Pine.LNX.4.44L0.0801171448590.5731-100000@iolanthe.rowland.org>	 <20080117232626.GC2905@ami.dom.local>	 <a8e1da0801171742o5520c3d9v577979f527f1a977@mail.gmail.com>	 <3ae72650801171755k85c4245i3b4c46a84ae8f52d@mail.gmail.com>	 <a8e1da0801171828n26b37be0oa8b1c3cbec5f83cb@mail.gmail.com>	 <1200626323.5640.21.camel@lov.site>	 <a8e1da0801172131h57097622h6d111133b6a0773d@mail.gmail.com>	 <20080118073836.GA1703@ff.dom.local>	 <a8e1da0801172348q575d6c2fs9f51e3e76d41c62@mail.gmail.com>	 <20080118082327.GC1703@ff.dom.local> <a8e1da0801180107w2d5a4be2r2b30d57a0d2b85ce@mail.gmail.com>
In-Reply-To: <a8e1da0801180107w2d5a4be2r2b30d57a0d2b85ce@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Young wrote, On 01/18/2008 10:07 AM:

> On Jan 18, 2008 4:23 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:

>> On Fri, Jan 18, 2008 at 03:48:02PM +0800, Dave Young wrote:

...

>>> 1) Using CLASS_NORMAL/CLASS_PARENT/CLASS_CHILD will be enough.
>>> or
>>> 2) Simply add SINGLE_LEVEL_NESTING in class_device_add and other
>>> class_device functions because it is the only possible nest-lock place
>>> as I know.


Dave, after looking a bit at this it seems you could be "mostly" right
with this 2). Maybe I've missed something (I didn't verify this yet), but
it looks like +1 level (SINGLE_LEVEL_NESTING) could be needed in:
class_device_add() (as you did), but probably also class_device_del() and
class_device_destroy().

...But, there seems to be "little" problem, if there is used this recursion
with: class_intf->add()/remove() in class_device_add()/del()?! Then Kay
is right about possibility of deeper nesting. If this path is really used,
and any of these class_device_* functions with locking are called, then
this patch couldn't work like this. So, there is a question: how deep
nesting is currently used here?

Regards,
Jarek P.

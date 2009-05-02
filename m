Return-Path: <linux-kernel-owner+w=401wt.eu-S1751635AbZEBEmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbZEBEmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 00:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZEBEmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 00:42:11 -0400
Received: from smtp-out.google.com ([216.239.33.17]:3038 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbZEBEmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 00:42:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=cbjvMPqWlDvDtKwZwLmuuWV04mbrPXykttTUberOo3iUfAYiLtOAc2zaTKeZHSfIF
	aUQTvceTBff+1mO/dnrfA==
MIME-Version: 1.0
In-Reply-To: <ac3eb2510905011928o26ae45efr2b23deafda76e1fc@mail.gmail.com>
References: <1241097822.2516.3.camel@poy>
	 <20090430222900.c13b63d5.akpm@linux-foundation.org>
	 <20090501061701.GB19234@kroah.com>
	 <20090430234312.a63fa5cf.akpm@linux-foundation.org>
	 <20090501065527.GA19773@kroah.com>
	 <a55d774e0905011824k11e06f61ibc9937a2b26fd9e0@mail.gmail.com>
	 <ac3eb2510905011848i51aef8e6wbe9506a13e67377d@mail.gmail.com>
	 <a55d774e0905011902y1827322ascd7d2eb42570d1dc@mail.gmail.com>
	 <ac3eb2510905011928o26ae45efr2b23deafda76e1fc@mail.gmail.com>
Date: Fri, 1 May 2009 21:42:04 -0700
Message-ID: <a55d774e0905012142p7acd1086kc5a10d834b021eaa@mail.gmail.com>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev tmpfs
From: Brian Swetland <swetland@google.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 1, 2009 at 7:28 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Sat, May 2, 2009 at 04:02, Brian Swetland <swetland@google.com> wrote:
>> On Fri, May 1, 2009 at 6:48 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>
>>>> I would love to have a way for the kernel to do something like devfs
>>>> (it'd let me kill some ugly userspace code on my side)....
>>>
>>> How are permissions defined in your environment? What's the set of
>>> permissions you need to apply?
>>
>> In our world we use groups to provide access to specific classes of
>> hardware resources (audio, video, display, dsp, etc) and processes
>> that have the appropriate permissions are arranged to run with
>> necessary additional groups for the hardware they need to access.
>
> These group numbers are always static on your system, and don't get
> changed while the system is running? Like you always assign gid X to
> all sound devices? Or do you need to manage them dynamically?

The gids for device access are static, part of the platform
definition.  I could imagine a model where the board file for a target
defined the ownership for devices or that was loaded in from userspace
at boot (just a table of path-match-string, uid, gid, perms).  Not
sure if that'd be considered too ugly, but it would certainly solve
the problem in a straightforward way.  Early on the "device ownership
policy" is installed and then userspace can leave everything to the
kernel.

The uids for applications are dynamic, assigned on app install (every
app gets its own uid).

> Do your device nodes permissions/ownership ever change on the running
> system after the device is alive?

We never change device node permissions or ownership at runtime.  I
could see situations in which that would be useful, but it's not
something that is currently used by the platform.

Brian

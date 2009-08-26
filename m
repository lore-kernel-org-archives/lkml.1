Return-Path: <linux-kernel-owner+w=401wt.eu-S933032AbZHZNpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032AbZHZNpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 09:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933019AbZHZNpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 09:45:42 -0400
Received: from mail.lang.hm ([64.81.33.126]:42182 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933017AbZHZNpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 09:45:41 -0400
Date: Wed, 26 Aug 2009 06:44:42 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Ric Wheeler <rwheeler@redhat.com>
cc: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
       Florian Weimer <fweimer@bfk.de>,
       Goswin von Brederlow <goswin-v-b@web.de>, Rob Landley <rob@landley.net>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org, corbet@lwn.net
Subject: Re: [patch] document flash/RAID dangers
In-Reply-To: <4A95349E.7010101@redhat.com>
Message-ID: <alpine.DEB.2.00.0908260643550.28411@asgard.lang.hm>
References: <20090825233701.GH4300@elf.ucw.cz> <4A947839.4010601@redhat.com> <20090826000657.GK4300@elf.ucw.cz> <4A947E05.8070406@redhat.com> <20090826002045.GO4300@elf.ucw.cz> <4A9481BE.1030308@redhat.com> <20090826003803.GP4300@elf.ucw.cz>
 <4A9485A6.1010803@redhat.com> <20090826112121.GD26595@elf.ucw.cz> <4A952370.50603@redhat.com> <20090826124058.GK32712@mit.edu> <4A95349E.7010101@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009, Ric Wheeler wrote:

> On 08/26/2009 08:40 AM, Theodore Tso wrote:
>> On Wed, Aug 26, 2009 at 07:58:40AM -0400, Ric Wheeler wrote:
>>>> Drive in raid 5 failed; hot spare was available (no idea about
>>>> UPS). System apparently locked up trying to talk to the failed drive,
>>>> or maybe admin just was not patient enough, so he just powercycled the
>>>> array. He lost the array.
>>>> 
>>>> So while most people will not agressively powercycle the RAID array,
>>>> drive failure still provokes little tested error paths, and getting
>>>> unclean shutdown is quite easy in such case.
>>> 
>>> Then what we need to document is do not power cycle an array during a
>>> rebuild, right?
>> 
>> Well, the softwar raid layer could be improved so that it implements
>> scrubbing by default (i.e., have the md package install a cron job to
>> implement a periodict scrub pass automatically).  The MD code could
>> also regularly check to make sure the hot spare is OK; the other
>> possibility is that hot spare, which hadn't been used in a long time,
>> had silently failed.
>
> Actually, MD does this scan already (not automatically, but you can set up a 
> simple cron job to kick off a periodic "check"). It is a delicate balance to 
> get the frequency of the scrubbing correct.

debian defaults to doing this once a month (first sunday of each month), 
on some of my systems this scrub takes almost a week to complete.

David Lang

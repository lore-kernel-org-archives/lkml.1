Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbXBSLNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbXBSLNj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 06:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932104AbXBSLNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 06:13:39 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:62699 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109AbXBSLNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 06:13:38 -0500
Message-ID: <45D98654.2020005@in.ibm.com>
Date: Mon, 19 Feb 2007 16:43:24 +0530
From: Balbir Singh <balbir@in.ibm.com>
Reply-To: balbir@in.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.9 (X11/20070103)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, ckrm-tech@lists.sourceforge.net, xemul@sw.ru,
       linux-mm@kvack.org, svaidy@linux.vnet.ibm.com, devel@openvz.org
Subject: Re: [RFC][PATCH][1/4] RSS controller setup
References: <20070219065019.3626.33947.sendpatchset@balbir-laptop> <20070219065026.3626.36882.sendpatchset@balbir-laptop> <20070219005727.da2acdab.akpm@linux-foundation.org> <6599ad830702190118r20b477d3q254c167c2fc2732@mail.gmail.com>
In-Reply-To: <6599ad830702190118r20b477d3q254c167c2fc2732@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On 2/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> This output is hard to parse and to extend.  I'd suggest either two
>> separate files, or multi-line output:
>>
>> usage: %lu kB
>> limit: %lu kB
> 
> Two separate files would be the container usage model that I
> envisaged, inherited from the way cpusets does things.
> 
> And in this case, it should definitely be the limit in one file,
> readable and writeable, and the usage in another, probably only
> readable.
> 
> Having to read a file called memctlr_usage to find the current limit
> sounds wrong.
> 

That sound right, I'll fix this.

> Hmm, I don't appear to have documented this yet, but I think a good
> naming scheme for container files is <subsystem>.<whatever> - i.e.
> these should be memctlr.usage and memctlr.limit. The existing
> grandfathered Cpusets names violate this, but I'm not sure there's a
> lot we can do about that.
> 

Why <subsystem>.<whatever>, dots are harder to parse using regular
expressions and sound DOS'ish. I'd prefer "_" to separate the
subsystem and whatever :-)

>> > +static int memctlr_populate(struct container_subsys *ss,
>> > +                             struct container *cont)
>> > +{
>> > +     int rc;
>> > +     if ((rc = container_add_file(cont, &memctlr_usage)) < 0)
>> > +             return rc;
>> > +     if ((rc = container_add_file(cont, &memctlr_limit)) < 0)
>>
>> Clean up the first file here?
> 
> Containers don't currently provide an API for a subsystem to clean up
> files from a directory - that's done automatically when the directory
> is deleted.
> 
> I think I'll probably change the API for container_add_file to return
> void, but mark an error in the container itself if something goes
> wrong - that way rather than all the subsystems having to check for
> error, container_populate_dir() can do so at the end of calling all
> the subsystems' populate methods.
> 

It should be easy to add container_remove_file() instead of marking
an error.

> Paul


-- 
	Warm Regards,
	Balbir Singh

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbXF1PlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbXF1PlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760922AbXF1Pkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:40:49 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42415 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759662AbXF1Pkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:40:47 -0400
Message-ID: <4683D570.2090104@zytor.com>
Date: Thu, 28 Jun 2007 11:36:16 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk> <20070628145308.GD5339@ucw.cz>
In-Reply-To: <20070628145308.GD5339@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Hi!
> 
>>> ... or, alternatively, add a subfield to the first field (which would
>>> entail escaping whatever separator we choose):
>>>
>>> /dev/md6 /export ext3 rw,data=ordered 0 0
>>> /dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
>>> /dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0
>> Hell, no.  The first field is in principle impossible to parse unless
>> you know the fs type.
>>
>> How about making a new file with sane format?  From the very
> 
> Well, what about /sysfs, with its one value per file rule?
> 

There are two reasons not to do it that way:

- atomicity
- backwards compatibility

Of these, I would argue the former is the most important.

Additionally, I don't think sysfs has the ability to present different 
structures on a per-process basis; keep in mind this isn't really 
/proc/mounts, but really /proc/<pid>/mounts.

	-hpa

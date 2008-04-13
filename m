Return-Path: <linux-kernel-owner+w=401wt.eu-S1757218AbYDMCj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218AbYDMCj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 22:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYDMCjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 22:39:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:52012 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbYDMCjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 22:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=SvZcni27ramakBMeT9v0ERlkyr9lkWg6H6af13rw+ORYSyvzbeAmnu+xMu2BQ8yrZXMBQaG5FSTqPVe00+eOMDHc1LtbU4Sd60NdU2AJBnCGgU3COhVT8oqAH8Hy9QLzDMWKiACgZjbOePX5w1jxyx+axahX6s3Om3lU+Q9bjjQ=
Message-ID: <48017248.4030600@gmail.com>
Date: Sun, 13 Apr 2008 11:39:04 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
References: <200804021524.27222.elendil@planet.nl> <200804021820.04610.elendil@planet.nl> <20080402194938.GI24237@csclub.uwaterloo.ca> <200804031947.07674.elendil@planet.nl>
In-Reply-To: <200804031947.07674.elendil@planet.nl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On Wednesday 02 April 2008, Lennart Sorensen wrote:
>>> Yes, that could be one way to implement it: load it and then check if
>>> that added any devices.
>> Well even if you see other disks doesn't mean you don't also have an old
>> IDE controller you want to use, so probably load it and see if it finds
>> any disks is the best bet after loading all the other probeable drivers
>> first.
> 
> I've decided (at least for now) to only do this f /sys/bus/isa is present.
> I added a check to see if there are additional devices in /sys/block after 
> loading ide-generic to decide whether or not to also include it in the 
> initrd for the installed system.
> 
> /sys/bus/isa is present for this machine so it works even if (as Ondrej 
> suggests) the controller is not actually on the ISA bus. We can always 
> extend the test if it turns out systems without ISA bus are also affected.
> 
> I'll also send out a call for testing specifically for this issue.
> 
> Thanks to you and Ondrej for the discussion.

Please be advised that some modern controllers are dual interfaced. 
Native one and legacy one.  The legacy one is SFF compliant and 
depending on configuration may appear at legacy IO addresses, so if you 
aren't careful, you can end up with two drivers driving the same 
hardware which usually doesn't end too well.  Loading generic drivers 
w/o knowing that it's needed is quite dangerous.  I would strongly 
advise against it.

-- 
tejun

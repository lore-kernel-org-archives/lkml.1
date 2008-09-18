Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYIRIqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYIRIqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 04:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbYIRIqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 04:46:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58897 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751854AbYIRIqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 04:46:35 -0400
Message-ID: <48D2150D.7040603@melbourne.sgi.com>
Date: Thu, 18 Sep 2008 18:45:01 +1000
From: Greg Banks <gnb@melbourne.sgi.com>
Organization: File Serving Technologies ; Silicon Graphics Inc.
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Martin Knoblauch <knobi@knobisoft.de>
CC: linux-nfs list <linux-nfs@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
References: <136998.55258.qm@web32606.mail.mud.yahoo.com>
In-Reply-To: <136998.55258.qm@web32606.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Knoblauch wrote:
> ----- Original Message ----
>
>   
>>
>> I think having a tunable for client readahead is an excellent idea,
>> although not to solve your particular problem.  The SLES10 kernel has a
>> patch which does precisely that, perhaps Neil could post it.
>>
>> I don't think there's a lot of point having both a module parameter and
>> a sysctl.
>>
>>     
>
>  Actually there is a good reason. The module parameter can be used to set the new value at load time and never bother again. The sysctl is very convenient when doing experiments.
>   
You can set module parameters after module load in
/sys/module/$module/parameters.
>  As Andrew already pointed out, the best solution would be a mount option.
Yep.
>  But that seems much more involved as my workaround patch.
>
>   
Yep.
>> A maximum of 15 is unwise.  I've found that (at least with the older
>> readahead mechanisms in SLES10) a multiple of 4 is required to preserve
>> rsize-alignment of READ rpcs to the server, which helps a lot with wide
>> RAID backends.  So in SGI we tune client readahead to 16.
>>
>>     
>
>  15 is the value that the Linux NFS client uses., at least since 2.6.3. 
It's a silly value.
> As it is not tunable up to today, the comment seems moot :-)  But it opens the questions:
>
> a) should 1 be the minimum, or 0?
>   
Turning off client RA entirely is potentially useful.
> b) can the backing_dev_info.ra_pages field safely be set to something higher than 15?
>   
Yes.  Did I mention 16 ?
>   
>> Your patch seems to have a bunch of other unrelated stuff mixed in.
>>
>>     
>
>  Yeah, someone already pointed out, that the Makefile hunk does not belong there. But you say "a bunch" - anything else?
>   
I rapidly scrolled past some stuff about 64bit inodes.
> Cheers
> Martin
> PS: Did we ever meet/mail when I was at SGI (1991-1997)?
>
>   
I'm more recent than that.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
Be like the squirrel.
I don't speak for SGI.


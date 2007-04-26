Return-Path: <linux-kernel-owner+w=401wt.eu-S1031373AbXDZRdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031373AbXDZRdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:33:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031371AbXDZRdr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:33:47 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:36932 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031373AbXDZRdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:33:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tF1FF6IKwVGa6uVE4TdR8q5xWnkTemD0LuwQOgP+mraoRzoLHKMpCCtqphYNlOmgBrtLFxVqO4RsL9d9KB5pcaehIQUpcN7SuJ+/pr64U27RhSTLo2uWbcDxdxAhOKBXzOMStdi8FzPMvza6PJRsX4lOn6KT6rU3ZUXcru5AQAE=
Message-ID: <4630E26D.2050703@gmail.com>
Date: Fri, 27 Apr 2007 02:33:33 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       greg@kroah.com
Subject: Re: [PATCH] sysfs: use different lockdep subclass for s_active deactivation
References: <a44ae5cd0704242215w1b474c52r7860f0d49bc64d6c@mail.gmail.com>	 <462EE4B7.6000708@gmail.com> <20070426145047.GF17130@htj.dyndns.org> <a44ae5cd0704261021n78780c71i4c8f7613d58dec54@mail.gmail.com>
In-Reply-To: <a44ae5cd0704261021n78780c71i4c8f7613d58dec54@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Miles Lane wrote:
> On 4/26/07, Tejun Heo <htejun@gmail.com> wrote:
>> A sysfs node can delete other sysfs files when accessed.  This results
>> in recursive s_active locking - read lock for file access, down lock
>> of the vicitim for deactivation.  Tell lockdep that it's okay.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> ---
>> Miles, please test this patch.  It should remove the lockdep warning.
>> Fixes for the other two problems will soon follow.
>>
>> Greg, Andrew, after all the fixes are verified, I'll merge the fixes
>> into the original patches and resend all the sysfs updates in better
>> shape.  Sorry about all the trouble.
> 
> Should I test this with 2.6.21-rc7-mm2?
> It doesn't apply cleanly.
> 
> # patch -p1 -l --dry-run < tejun.patch
> patching file fs/sysfs/dir.c
> Hunk #1 succeeded at 31 with fuzz 1 (offset -29 lines).
> patching file fs/sysfs/sysfs.h
> Hunk #1 succeeded at 40 (offset -1 lines).
> Hunk #2 succeeded at 182 with fuzz 1 (offset -1 lines).

It's in the middle of gregkh patch series but you can safely ignore the
fuzzes.

-- 
tejun

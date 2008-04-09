Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbYDIJeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbYDIJeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 05:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYDIJeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 05:34:19 -0400
Received: from ms0.nttdata.co.jp ([163.135.193.231]:56126 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbYDIJeR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 05:34:17 -0400
X-Greylist: delayed 3395 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Apr 2008 05:34:16 EDT
Message-ID: <47FC8052.9070409@nttdata.co.jp>
Date: Wed, 09 Apr 2008 17:37:38 +0900
From: Toshiharu Harada <haradats@nttdata.co.jp>
Organization: NTT DATA CORPORATION
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Paul Moore <paul.moore@hp.com>
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-netdev <netdev@vger.kernel.org>
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
References: <20080404122242.867070732@I-love.SAKURA.ne.jp> <20080404122408.986477936@I-love.SAKURA.ne.jp> <200804071140.59247.paul.moore@hp.com>
In-Reply-To: <200804071140.59247.paul.moore@hp.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
X-OriginalArrivalTime: 09 Apr 2008 08:37:38.0686 (UTC) FILETIME=[F7C761E0:01C89A1C]
Content-Transfer-Encoding: 8BIT
X-MIME-Autoconverted: from 8bit to quoted-printable by mail0.nttdata.co.jp id m398bddo008662
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/8/2008 12:40 AM, Paul Moore wrote:
> On Friday 04 April 2008 8:23:12 am Tetsuo Handa wrote:
>> This file contains modifications against kernel source code
>> needed to use TOMOYO Linux 1.6.
>>
>> Although LSM hooks are provided for performing access control,
>> TOMOYO Linux 1.6 doesn't use LSM because of the following reasons.
> 
> Hello,
> 
> I understand your frustration with the existing LSM hooks/API and your 
> reasoning for abandoning LSM in favor of a new set of hooks, however, I 
> think this sets a dangerous precedence which could result in an 
> abundance of security related hooks scattered throughout the kernel.  I 
> would much rather see the LSM API extended/tweaked to support the needs 
> of SAKURA and TOMOYO than ignored and duplicated; I suspect several 
> others will say the same.
> 
> You have made good progress with TOMOYO so far and if I can remember 
> correctly you really only have one hurdle left, the VFS portion.  
> Please continue to seek a solution to this that fits within the LSM 
> framework.
> 
> Thank you.

Thank you for your comments and concern.

I realized that we should have included the reason why we decided to
post non-LSM version. Let me explain the reason and the history.

We started developing TOMOYO Linux as original patch sets against
2.4 vanilla kernel. We understand the role of LSM, so we ported
TOMOYO Linux to use LSM and submitted it to the LKML on 13 June 2007.
We kept working to reflect feedbacks from the community and believe
no critical Nack remains.

http://lwn.net/Articles/238049/
http://lwn.net/Articles/246930/
http://lwn.net/Articles/252652/
http://lwn.net/Articles/254503/
http://lwn.net/Articles/258905/
http://lwn.net/Articles/263179/
http://lwn.net/Articles/264187/
http://lwn.net/Articles/276603/

Still there remains an issue of LSM limitation (vfsmount parameter
isn’t passed to LSM).

LWN article 239962 says, "At the 2006 summit, Linus took a clear
position that the use of pathnames for security policies seemed
reasonable to him". Current LSM implementation is sufficient for SELinux
and other label based MACs but not for pathname-based MACs.
This has been argued in the AppAmor thread for quite a long time.
Though proposals had been posted by AppArmor and TOMOYO Linux project,
none has been merged until now.

We apologize for the confusion we caused in the last posting,
but we don't want to give up returning our work to the mainline. 

We cordially request LSM changes to pass vfsmount parameters.

Finally, the following links are our answers to the Linux Weather Forecast. (http://www.linux-foundation.org/en/Linux_Weather_Forecast/security#TOMOYO_Linux)

http://tomoyo.sourceforge.jp/wiki-e/?WhatIs#comparison
http://sourceforge.jp/projects/tomoyo/document/fosdem2008.pdf
http://sourceforge.jp/projects/tomoyo/document/PacSec2007-handout.pdf

Regards,
Toshiharu Harada
NTT DATA CORPORATION


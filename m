Return-Path: <linux-kernel-owner+w=401wt.eu-S1765430AbYB1T6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765430AbYB1T6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 14:58:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764477AbYB1TyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 14:54:11 -0500
Received: from gv-out-0910.google.com ([216.239.58.190]:45318 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764435AbYB1TyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 14:54:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=WZqUVbpDQlcKfoA+akyPi9d+329/hhdGptVcbpKIual103XNL9K+rNHNgQRjqWzOv3sVvDn4nnKO9IK4YRBhyiGxPsprYoNC1aEh8/lXp7r43QQIyw5/5QkdaNLKw6F0DKMS+KY7Crgvhvm/zrm+4KvABCcoTM7pGQUOe+0VpEY=
Message-ID: <2c0942db0802281154y3176e847g8b9a4091df5cc8af@mail.gmail.com>
Date: Thu, 28 Feb 2008 11:54:04 -0800
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: Interactivity issue in 2.6.25-rc3
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080228191824.GA20019@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080228184407.GA7117@localhost.ift.unesp.br>
	 <20080228191824.GA20019@elte.hu>
X-Google-Sender-Auth: 500bb592b049d268
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 11:18 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
>  * Carlos R. Mafra <crmafra2@gmail.com> wrote:
>
>  > I want to report a bad interactivity which happened in my desktop
>  > running the latest kernel (2.6.25-rc3-00081-g7704a8b).
>  >
>  > I tried to play 'flightgear' and the desktop became _very_ slow while
>  > flightgear was "loading scenery objects" (a task which never finished
>  > and I could not play it).
>  >
>  > The desktop is a P4 @ 3.0 GHz, 512MB, with the nv graphics driver.
>
>  yes, but this means you run the soft-3D driver under Xorg, right? That
>  is known to starve its clients. The stats you sent show no worse than a
>  few tens of msecs delays caused by CPU scheduling itself:
>
>   mrxvt (3730, #threads: 1)
>   se.wait_max                        :            18.679129
>
>  so the scheduler kept things within the ~40 msecs default latency
>  target:
>
>   .sysctl_sched_latency                    : 40.000000

[...]

>> As I have the group scheduler enabled, I tried to run flightgear as
>> root to see what happens

Also, please try disabling the group scheduler and run the test again.
The group scheduler has known bad interactivity issues. Also be on the
watch for any abnormally high disk activity, to rule out starvation
due to the kernel choosing poor candidates for swap-in/swap-out.
(Running a vmstat 1 in a console ahead of time and watching for high
IO Wait -- the last column printed -- will give you a good indicator
other than the drive LED.)

Ray

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbXEOI6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbXEOI6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbXEOI6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:58:05 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:41360 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883AbXEOI6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:58:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=imbCfKbnVmfaWsiho7/rGPgk/HUt38B9mOlTDwjDSJhsYiorVCPJ5/8qKMpe5VOAU+vN1sB5enepI2FPU1w29cSMLxtT0nYcLuEXyHeDuO1qXoYgjMbYg8aGrcWE4FaLpiL0FtKOiUspUuOnOkBlDD7/UMwL2oofhjz0bDjAJRg=
Message-ID: <a2ebde260705150158m45286bd6u5007be863b6ff791@mail.gmail.com>
Date: Tue, 15 May 2007 16:58:02 +0800
From: "Dong Feng" <middle.fengdong@gmail.com>
To: "Learning Linux" <learninglinux4@gmail.com>
Subject: Re: Why can't we sleep in an ISR?
Cc: "pradeep singh" <2500.pradeep@gmail.com>,
       "Bahadir Balban" <bahadir.balban@gmail.com>, kernelnewbies@nl.linux.org,
       linux-newbie@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <9f1dc2cf0705150140k1fef87acvd774c7e171e4a660@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f1dc2cf0705132337k13aa3ccesc575d4550492a24e@mail.gmail.com>
	 <366312910705140010m78b215a2t1753445e81120288@mail.gmail.com>
	 <9f1dc2cf0705140016w6d8f44f9wec7586e7879af873@mail.gmail.com>
	 <7ac1e90c0705140824i54e1c43ela3ab3d89827c0339@mail.gmail.com>
	 <366312910705142217geba69dbm98a6c0bf2aabb937@mail.gmail.com>
	 <a2ebde260705142345m440c70fbu33934334fbb69f8e@mail.gmail.com>
	 <366312910705150010p623f9732mc498f457245d23a1@mail.gmail.com>
	 <a2ebde260705150028j16cc12a2ya6d5906c97ce193b@mail.gmail.com>
	 <9f1dc2cf0705150140k1fef87acvd774c7e171e4a660@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, you are right in this regard. An interrupt handler does steal the
time slice from the interrupted process.

So now I think it is considered an acceptable deviation in calculating
the process run time as well as determine process scheduling because
an ISR should take very short time to return, in part as a consequence
of the rule that ISR should not sleep.


2007/5/15, Learning Linux <learninglinux4@gmail.com>:
> > The interrupt handler's execution time will definitely defer the
> > execution of the process, but I think it does not steal the process's
> > time slice (the time_slice field not subtracted).
>
> It will definitely be substracted from the process's time slice.
> Because the timeslice is substracted in timer interrupt, and does not
> differenciate if the process is executing ISR or not.
>

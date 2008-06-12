Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbYFLGgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbYFLGgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 02:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYFLGgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 02:36:45 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:56002 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221AbYFLGgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 02:36:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=J/bTYN/hcfVZcu85ei57MCqvOun6B8FJFJflH0jH0HZPlD8qP5m21b8XtxjdcTMffr
         SE0zoCSBnUupSU9fJwojY7Jvs2wv6PpA1mnvENADO5dO+yeJ8iU/LdFGSW1SeFV23rOv
         13aS3g0HSaTERAWgnrQgLwys4xDTAo4rT4a+I=
Message-ID: <dd18b0c30806112336ma74115cta1923f7b08dcc2d@mail.gmail.com>
Date: Thu, 12 Jun 2008 06:36:42 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: macbook pro dvd playback after suspend Buffer I/O error
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <4850C1AC.4090809@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com>
	 <485048EC.2080608@gmail.com>
	 <dd18b0c30806111527x22fa895em230ceade4712f073@mail.gmail.com>
	 <4850794F.3000200@gmail.com>
	 <dd18b0c30806111910j4b127c32rbd546f885731e18c@mail.gmail.com>
	 <dd18b0c30806111913gf505c05j479a6a682c2cdd28@mail.gmail.com>
	 <4850A2F8.3050404@gmail.com>
	 <dd18b0c30806112222k60e411dfs98e4cc7f64938b5b@mail.gmail.com>
	 <dd18b0c30806112315x70dee219oa6738de3e22d4939@mail.gmail.com>
	 <4850C1AC.4090809@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 6:26 AM, Tejun Heo <htejun@gmail.com> wrote:
> Justin Mattock wrote:
>> O.K. applied the patch and did what you have described,(except for
>> sysctl -w / ended up inserting dev.scsi.logging_level=1 in
>> /etc/sysctl.conf)
>> This is what dd reported:(same as before)
>> dd: reading `/dev/sr0':Input/output error
>> 41+1 records in
>> 41+1 records out
>> 43122688 bytes (43 MB) copied, 41.0967 seconds, 1.0 MB/s
>>
>> Attached is dmesg of using dd on the first suspend, and playing a dvd
>> on the second.
>
> Ah.. okay.  The drive was becoming ready and the read commands were
> retried too fast.  The drive I tested on was fast enough to deliver the
> data but yours wasn't.  Hmmm.... This is difficult.  This also poses
> problems to live cd distros, I think.  We probably need to make sr wait
> for device readiness.  Maybe it's best to put TUR waiting in read error
> handling.  I'll think about it.
>
> Thanks.
>
> --
> tejun
>

Yeah, take you're time. Maybe it's easier  to have mplayer or which
ever media player wait for the drive. i.g.
under OSX, the media player pauses until the drive does it's thing,
and then resumes.(but this would be for the suspend aspect)
As for the live distro part I'd have to think as well. Let me know
what you think.
regards;
-- 
Justin P. Mattock

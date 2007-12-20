Return-Path: <linux-kernel-owner+w=401wt.eu-S932816AbXLTSGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932816AbXLTSGU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 13:06:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760449AbXLTSGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 13:06:01 -0500
Received: from wr-out-0506.google.com ([64.233.184.227]:36493 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbXLTSF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 13:05:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=q3fwZRxEXu6DSKX7OMs75pVnkrYWeYLm1y1MChHAnk+q5udc4sCWrsS9m1gHTfL3LJFTwE5ZDwXhraCO0Fx0SquZhpvQgLfM4pifq0M7suuXQaxlQ1ZY9YxcruwAqh10MMBy1yGFtE/ENkjJqkI+v8rt2UsLekcmusCh38fDgdo=
Message-ID: <82e4877d0712201005u3e1abd4t675b3b0f21b8ff4c@mail.gmail.com>
Date: Thu, 20 Dec 2007 13:05:58 -0500
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [PATCH] sky2: Use deferrable timer for watchdog
Cc: netdev@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071220095121.7859c023@deepthought>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0712182008160.3616@mini.warudkars.net>
	 <20071220091603.0d69b045@deepthought>
	 <823114761-1198171803-cardhu_decombobulator_blackberry.rim.net-937108990-@bxe019.bisx.prod.on.blackberry>
	 <20071220095121.7859c023@deepthought>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 20, 2007 12:51 PM, Stephen Hemminger
<shemminger@linux-foundation.org> wrote:
>
> Quit top-posting!
>
> If this is the case then the whole usage of round_jiffies() is bogus. All users of round_jiffies()
> should just be converted to deferrable??  I am a bit concerned that if deferrable gets used everywhere
> then a strange situation would occur where all timers were waiting for some other timer to finally
> happen, kind of a wierd timelock situation. Like the old chip/dale cartoon:
>  "you first, no you first, after you mister chip, no after you mister dale,..."
>

Haha - I thought about this too. I think there should be mechanism
where the machine does not idle infinitely even if there are no
non-deferrable timers. Something like an affordable QoS for non
deferrable timers - the kernel wakes up after that interval and runs
all deferrable timers  even if nothing non-deferrable is set to run.
So we still get advantage of not having to wake individually for each
timer and the non-deferrable timers do get all run in reasonable
amount of time.

Who knows Thomas/Ingo already built in something of that nature or effect?!

Parag

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbXEEP2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbXEEP2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 11:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755288AbXEEP2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 11:28:41 -0400
Received: from smtp.nokia.com ([131.228.20.170]:47076 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbXEEP2i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 11:28:38 -0400
Subject: Re: [PATCH] UBI: dereference after kfree in create_vtbl
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Florin Malita <fmalita@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-mtd@lists.infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <a781481a0705050648l19b316acyf3d52b0545e18344@mail.gmail.com>
References: <463A04A5.5030103@gmail.com>
	 <a781481a0705041442h37453fb6k26d04eb5356e9dc0@mail.gmail.com>
	 <463BC019.40305@gmail.com>
	 <a781481a0705042055u5e9ba060w95da83b0fbeff76a@mail.gmail.com>
	 <1178351711.3659.54.camel@sauron>
	 <a781481a0705050526r13445d60j737a6c2015402dcc@mail.gmail.com>
	 <1178371103.3659.115.camel@sauron>
	 <a781481a0705050648l19b316acyf3d52b0545e18344@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 05 May 2007 16:59:22 +0300
Message-Id: <1178373562.3659.144.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 05 May 2007 13:59:22.0621 (UTC) FILETIME=[955F1AD0:01C78F1D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-05 at 19:18 +0530, Satyam Sharma wrote:
> Well, you're developing / maintaining this right now, so it's your
> call. Though I bet most people would find keeping that list_add_tail
> local to scan.c more tasteful.

I do not think so. If you are interested, try to find "UBI take 2"
patches in lkml. Look how it looked liked. It consisted of many
independent units and units could access other units _only_ via
interfaces. I would do what you say there.

Read Teo's comments - I actually now agree with them. And after I had
changed UBI i got rid of several thousands lines of code, and the code
became simpler.

So, my argument is:
1. It makes no sense to introduce one more non-static function to _just_
encapsulate list_add_tail and _just_ for one caller.
2. It is _C_, it is _kernel_, and it is OK sometimes _not_ to follow
computer since rules.

> I wish you'd commented it better than "This function returns zero in
> case of success and a negative error code in case of failure." in that
> case :-)
Agreed, I'll add more comments, thanks.

> Again, you're developing and maintaining this right now, so it's your
> call. Though it would be easier on you if you remove these exceptions
> that could be quite easily removed, actually.
I do not see any nice way to do this. If you suggest one, I will do.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)


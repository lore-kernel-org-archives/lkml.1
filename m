Return-Path: <linux-kernel-owner+w=401wt.eu-S1754925AbZDMXvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925AbZDMXvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 19:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682AbZDMXu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 19:50:59 -0400
Received: from easi.embeddedalley.com ([71.6.201.124]:52452 "HELO
	easi.embeddedalley.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753332AbZDMXu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 19:50:59 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Apr 2009 19:50:59 EDT
In-Reply-To: <20090413160814.1c335d1d.akpm@linux-foundation.org>
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com> <20090413160814.1c335d1d.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <298A09AD-495E-4671-84A1-B831826424A8@embeddedalley.com>
Cc: linux-kernel@vger.kernel.org, menage@google.com,
       containers@lists.linux-foundation.org
Content-Transfer-Encoding: 7bit
From: Dan Malek <dan@embeddedalley.com>
Subject: Re: [PATCH] Memory usage limit notification addition to memcg
Date: Mon, 13 Apr 2009 16:45:17 -0700
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, I'll rewrite and resubmit the patch with suggested updates.
Comments below...

On Apr 13, 2009, at 4:08 PM, Andrew Morton wrote:

> We've run into problems in the past where a percentage number is too
> coarse on large-memory systems.
>
> Proabably that won't be an issue here, but I invite you to convince us
> of this ;)

The challenge here is that the absolute limit of the memcg can
be dynamically changed, so I wanted to avoid a couple of problems.
One is just a system configuration error where someone forgets
to modify both.  For example, if you start with the memcg limit of 100M,
and the notification limit to 80M, then come back and change the memcg
limit to 90M (or worse, < 80M) you now have a clearly incorrect
configuration.   Another problem is the operation isn't atomic, at some
point during the changes, even if you remember to do it correctly, you
will have the two values not representing what you really want.  It
could trigger an erroneous notification, or simply OOM kill before you
get the configuration correct.

If an integer number turns out to not be sufficient, we could change  
this
to some fixed point representation and adjust the arithmetic in the  
tests.
I believe the integer number will be fine, even in large memory systems.
This is just a notification model, if we want something more fine  
grained
I believe it would need different semantics.

> Does it support select()/poll()/eventfd()/etc?

No.  Unfortunately this is a cgroup implementation limitation.
My TODO list includes updating cgroups to allow this, using
this notification as an example.

> Stylistic trick: here, please add

Will do, including some others to get rid of ifdefs.

> ifdefs-in-c make kernel developers sad.

I know.  I'll make them go away.

I'll fix it up and resubmit shortly.

Thanks.

	-- Dan


Return-Path: <linux-kernel-owner+w=401wt.eu-S1762771AbXE1UvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762771AbXE1UvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 16:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbXE1UvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 16:51:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:48208 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbXE1UvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 16:51:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=TtSQI7oX2ba54ZTSXF0VbS8hTdWSfj6VRqgu1SUAWmUUMbyv+EpM/kLwDJpNy5o3XY2AGazrwufjWqClgkIBbZmVxWssjHrH9PS/uuj4RKYUcIu8EYBqR+BuJkv2MqVQzTF8EitRabVO3G4ZyG0A+y5UC3ZyZ1lvZaPJ3n0b+Fs=
Message-ID: <2c0942db0705281351g450bd0c6u31e634757dfa8ac0@mail.gmail.com>
Date: Mon, 28 May 2007 13:51:15 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH -mm 3/3] PM: Disable _request_firmware before hibernation/suspend
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "pm list" <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Nigel Cunningham" <nigel@nigel.suspend2.net>,
       "Pavel Machek" <pavel@ucw.cz>, "Oliver Neukum" <oliver@neukum.org>
In-Reply-To: <200705281943.25129.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0705281151250.22682-100000@netrider.rowland.org>
	 <200705281943.25129.rjw@sisk.pl>
X-Google-Sender-Auth: 15b97bf39b226855
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, 28 May 2007 17:55, Alan Stern wrote:
> > You're using the PM_PRE_FREEZE and PM_POST_THAW notifiers for both this
> > and the userspace helper change.  Is it your intention that drivers
> > should continue to request these services but encounter an error if the
> > request occurs at the wrong time?  Or do you expect drivers to use the
> > notifier chains to know when they shouldn't make any requests?
>
> In fact, I'd like drivers to use notifiers to actually load the firmware into
> memory before hibernation/suspend.  Namely, if there's PM_PRE_FREEZE, the
> driver calls request_firmware() from within the notifier and saves the firmware
> in memory for future use, if need be.  Later, when PM_POST_THAW comes, the
> memory holding the firmware is released.
>
> Unfortunately there are drivers that call request_firmware() directly from
> .resume() which blocks until timeout expires and fails anyway.  I just wanted
> this to fail immediately, without waiting.

Stupid question time. Wouldn't it just be easier to have
request_firmware() keep a copy of the firmware once it's been loaded?
We're not talking about a lot of memory that would be wasted, and that
way no drivers have to be changed.

Ray

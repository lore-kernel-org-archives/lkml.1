Return-Path: <linux-kernel-owner+w=401wt.eu-S1031156AbXD1Whh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031156AbXD1Whh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031283AbXD1Whh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:37:37 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:27309 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031156AbXD1Whg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:37:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=g2V6+Qgt9MVXLDztfYXxKlC5pfn9B+ecic1F+iV8B6DHwBHUJfJiZKvZlkaejRT801ekEDT1O9TOuJZnj5yqkqkTVIRzf5j9V5c3xf/0pPjRcVCYUTMS2JgnQZl0Tvqy/b4X/S7Xtp2McFNgMa9R4qPnfbF/rvpTCegyVapulpM=
Message-ID: <75b66ecd0704281537s54134967ybc3ddef0b87b6bf5@mail.gmail.com>
Date: Sat, 28 Apr 2007 18:37:35 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: tglx@linutronix.de
Subject: Re: High Resolution Timer DOS
Cc: "matthieu castet" <castet.matthieu@free.fr>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <1177798389.7646.320.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4633C269.9050806@free.fr>
	 <1177798389.7646.320.camel@localhost.localdomain>
X-Google-Sender-Auth: 19d547f1bbd3ccc4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/07, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Well, it is not really a DoS. The rescheduling of the process is limited
> by the scheduler and the available CPU time (depending on the number of
> runnable tasks in the system).

Shouldn't an unprivileged process be rate limited somehow to avoid
flooding the machine with interrupts?  We restrict nonroot users from
setting the RTC interrupt rate higher than 64Hz for a similar reason
(granted, this limit dates back to the 486 days and should probably be
increased to 1024 Hz).

Root and SCHED_FIFO tasks could be exempt from rate limiting, to avoid
the need to introduce a new rlimit which would take years for
userspace to catch up to.

Lee

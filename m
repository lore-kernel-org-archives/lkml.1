Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbYACAQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbYACAQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:16:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbYACAQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:16:52 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:12723 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbYACAQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:16:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=SYDugeE++2YzgdO8s+cQjZDp5qlWs/gUoTA+SJyaEt4Jf269iZRN38h6qg46vqWY7EunUpW8LTqkyuo62G3WENRTi/kZx4xn4vY8u7epefJK3/2oHfyjPfmqjjeHQumL5MmLD61B3xpp+Qv0FuuRcrMQXC7WTiRuPvRb2vHMBBc=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Matthias Schniedermeyer <ms@citd.de>
Subject: Re: Why is deleting (or reading) files not counted as IO-Wait in top?
Date: Thu, 3 Jan 2008 02:16:44 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
References: <20080102193503.GA31414@citd.de>
In-Reply-To: <20080102193503.GA31414@citd.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801030216.44446.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 2 January 2008 21:35:03 Matthias Schniedermeyer wrote:
> Hi
> 
> 
> Currently i'm deleting about 500.000 files on a XFS-filesystem which 
> takes a few minutes, as i had a top open i saw that 'wa' is shown as 
> 0.0% (Nothing else running currently) and everything except 'id' is near 
> the bottom too. Kernel is 2.6.23.11.
> 
> So, as 'rm -rf' is essentially a IO (or seek, to be more correct)-bound 
> task, shouldn't that count as "Waiting for IO"?
> 
> The man-page of top says:
> 'Amount of time the CPU has been waiting for I/O to complete.'
> 
> But AFAICT wa only seams to be (ac)counted for writing and not for 
> reading. I come to that conclusion because, when i fire 'sync' i can see 
> some percent wa for a few seconds.
> 
> 
> 
> 
> Bis denn
> 


The IOWAIT time is the IDLE time that was spent waiting
for I/O. (meaning that there were no tasks running, but some were waiting on I/O)

Thus if you have another task that is not I/O bound, it can run in that time,
and ideally, you shouldn't notice any I/O slowdown, but the iowait time will decrease.

It wasn't the case before CFS introduction. I did few tests that showed almost 50% slowdown 
when running another task in that iowait time.
It is not longer a problem with CFS.


Regards,
	Maxim Levitsky

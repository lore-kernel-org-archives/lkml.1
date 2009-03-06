Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbZCFWt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbZCFWt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 17:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753853AbZCFWtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 17:49:16 -0500
Received: from yw-out-2324.google.com ([74.125.46.29]:40937 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZCFWtP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 17:49:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BoE/BvtZYh6wUdWcaekz7RKUtrhxAzXNul0vHIxzPjIqMfKadN5CSnJwojgKJFBc76
         hxuNbjJ+jIygHp9jGfAXPVXvB1QHvKkCQwO0V8JdOXs7np+A4ck8yYpYgDJrtVQnZoWv
         wh2PNbz2jzJelsfQFoeHC9aqYoNTE5wfTEaqs=
MIME-Version: 1.0
In-Reply-To: <20090306143806.3b126ab4.akpm@linux-foundation.org>
References: <1236321780-28718-1-git-send-email-cooloney@kernel.org>
	 <1236321780-28718-5-git-send-email-cooloney@kernel.org>
	 <20090306143806.3b126ab4.akpm@linux-foundation.org>
Date: Fri, 6 Mar 2009 17:49:13 -0500
Message-ID: <8bd0f97a0903061449w66c672a7r5197a175b16c61a4@mail.gmail.com>
Subject: Re: [PATCH 04/18] Blackfin Serial Driver: Change hardware flowcontrol 
	from poll to interrupt driven.
From: Mike Frysinger <vapier.adi@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bryan Wu <cooloney@kernel.org>, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, sonic.zhang@analog.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 6, 2009 at 17:38, Andrew Morton wrote:
> On Fri,  6 Mar 2009 14:42:46 +0800 Bryan Wu wrote:
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> Only CTS bit is affected.
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>> Signed-off-by: Bryan Wu <cooloney@kernel.org>
>
> Another completely useless changelog.

the summary, while brief, describes the change: the flowcontrol is
currently implemented by polling, but this changes it to an interrupt
based system

> Your [PATCH 00/18] email described all these patches as
> needed-in-2.6.29 bugfixes.  As far as I can tell (based on almost zero
> information), this patch is not a bugfix.

because the current implementation is polling (busy waiting), the
kernel will basically hang when the remote asserts hardware
flowcontrol pins.  if this is only asserted for short periods (less
than 1 char time), then it's not really noticed ... but it still
destroys latencies.
-mike

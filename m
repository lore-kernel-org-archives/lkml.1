Return-Path: <linux-kernel-owner+w=401wt.eu-S1760946AbZD1H6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760946AbZD1H6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZD1H61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:58:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:6908 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbZD1H60 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:58:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Q1N3KfrCRvJc4fxbv6tVs5Cw1Ft8HNSxBLAETL7qnmJbjiUIQltvyeJQLa6IBGVN3a
         2pvyPMX9NJQ9eBSN9qQ84fNPhMjquCZeaMo533M3npKQ56V+H7hCLh+yAUm+BJaJKDlE
         W4opkRJe13KSVWTys9VwF3uIbbZhsF0qcfCHg=
MIME-Version: 1.0
In-Reply-To: <1240904919.7620.73.camel@twins>
References: <20090428044426.GA5035@eskimo.com>
	 <20090428143019.EBBF.A69D9226@jp.fujitsu.com>
	 <1240904919.7620.73.camel@twins>
Date: Tue, 28 Apr 2009 13:28:25 +0530
X-Google-Sender-Auth: a33264b7b4311e20
Message-ID: <661de9470904280058ub16c66bi6a52d36ca4c2d52c@mail.gmail.com>
Subject: Re: Swappiness vs. mmap() and interactive response
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Elladan <elladan@eskimo.com>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 1:18 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2009-04-28 at 14:35 +0900, KOSAKI Motohiro wrote:
>> (cc to linux-mm and Rik)
>>
>>
>> > Hi,
>> >
>> > So, I just set up Ubuntu Jaunty (using Linux 2.6.28) on a quad core phenom box,
>> > and then I did the following (with XFS over LVM):
>> >
>> > mv /500gig/of/data/on/disk/one /disk/two
>> >
>> > This quickly caused the system to. grind.. to... a.... complete..... halt.
>> > Basically every UI operation, including the mouse in Xorg, started experiencing
>> > multiple second lag and delays.  This made the system essentially unusable --
>> > for example, just flipping to the window where the "mv" command was running
>> > took 10 seconds on more than one occasion.  Basically a "click and get coffee"
>> > interface.
>>
>> I have some question and request.
>>
>> 1. please post your /proc/meminfo
>> 2. Do above copy make tons swap-out? IOW your disk read much faster than write?
>> 3. cache limitation of memcgroup solve this problem?
>> 4. Which disk have your /bin and /usr/bin?
>>
>
> FWIW I fundamentally object to 3 as being a solution.
>

memcgroup were not created to solve latency problems, but they do
isolate memory and if that helps latency, I don't see why that is a
problem. I don't think isolating applications that we think are not
important and interfere or consume more resources than desired is a
bad solution.

> I still think the idea of read-ahead driven drop-behind is a good one,
> alas last time we brought that up people thought differently.

I vaguely remember the patches, but can't recollect the details.

Balbir

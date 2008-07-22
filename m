Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYGVOCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYGVOCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750770AbYGVOCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:02:31 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:42982 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYGVOCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:02:31 -0400
Message-ID: <4885E8F8.1050207@keyaccess.nl>
Date: Tue, 22 Jul 2008 16:04:40 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [RFC] Imprecise timers.
References: <1216695757.18980.16.camel@shinybook.infradead.org>	<488589E6.5070300@keyaccess.nl> <20080722055421.2023d261@infradead.org>
In-Reply-To: <20080722055421.2023d261@infradead.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22-07-08 14:54, Arjan van de Ven wrote:

> On Tue, 22 Jul 2008 09:19:02 +0200
> Rene Herman <rene.herman@keyaccess.nl> wrote:
> 
>> On 22-07-08 05:02, David Woodhouse wrote:
>>
>>> Many users of timers don't really care too much about exactly when
>>> their timer fires -- and waking a CPU to satisfy such a timer is a
>>> waste of power. This patch implements a 'range' timer which will
>>> fire at a 'convenient' moment within given constraints.
>>>
>>> It's implemented by a deferrable timer at the beginning of the
>>> range, which will run some time later when the CPU happens to be
>>> awake. And a non-deferrable timer at the hard deadline, to ensure
>>> it really does happen by then.
>> Are there actually users for this (not just in theory)? The
>> deferrable timer sort of sounds like all I'd ever want if I, as you
>> say, wouldn't really care...
> 
> there's a few; mostly around hardware timeout..For example Stephen want
> it for his drivers.

Hardware I've dealt with is (almost? can't remember anything else) 
exlusively minimal delays and as such this thing seemed like perhaps a 
bit over-apisized...

> EXT3 journal flushing is another one where we can easily say 
> "between 4 and 7 seconds" rather than "exactly at 5"

This a nice-ish example though. It might be considered necessary to make 
the current commit delay when set explicitly be the non-deferrable upper 
bound but almost none do I guess.

Rene.

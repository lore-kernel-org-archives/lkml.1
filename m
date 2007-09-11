Return-Path: <linux-kernel-owner+w=401wt.eu-S1763697AbXIKXQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763697AbXIKXQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 19:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758670AbXIKXQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 19:16:32 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:33963 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613AbXIKXQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 19:16:32 -0400
Message-ID: <46E721C6.8030109@gmail.com>
Date: Wed, 12 Sep 2007 01:16:22 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>
CC: Adrian McMenamin <lkmladrian@gmail.com>, linux-kernel@vger.kernel.org,
       linuxsh-dev@lists.sourceforge.net, Paul Mundt <lethal@linux-sh.org>
Subject: Re: time_after - what on earth???
References: <8b67d60709111505u61771a1do74c82a55430ec214@mail.gmail.com> <46E7128D.1080006@gmail.com> <8b67d60709111515m5b45c57emef5cc2f74795ed7a@mail.gmail.com> <46E7145D.10907@gmail.com> <20070911230940.GA7070@atjola.homenet>
In-Reply-To: <20070911230940.GA7070@atjola.homenet>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2007 01:09 AM, Björn Steinbrink wrote:
> On 2007.09.12 00:19:09 +0200, Rene Herman wrote:
>> On 09/12/2007 12:15 AM, Adrian McMenamin wrote:
>>
>>> On 11/09/2007, Rene Herman <rene.herman@gmail.com> wrote:
>>>> On 09/12/2007 12:05 AM, Adrian McMenamin wrote:
>>>>
>>>>> OK, why does this line occasionally return true:
> 
> What exactly is "occassionally"?  Does it happen more than once per
> boot? If not, and it happens after a certain time after booting, it
> might be wrapping of the jiffie counter (see below).
> 
>>>>>       if ((maple_dev->interval > 0) && (jiffies >maple_dev->when))
>>>>>
>>>>> while this one never does (no other changes made):
>>>>>
>>>>> if  ((maple_dev->interval > 0) && (time_after(jiffies, 
>>>>> maple_dev->when)))
>>>> Is maple_dev->when an unsigned long?
>>>>
>>> Yes. Does that make a difference?
>> If it had been a signed type, it could've wrapped to something you didn't 
>> expect, explaining the difference at least...
>>
>> With an unsigned long, the only diference should be that time_after() deals 
>> with jiffie wrapping which I assume is not an actual problem here. I'll 
>> retreat into the shades again... ;-(
> 
> If "occasionally" is limited to once per boot, it might be jiffie
> wrapping. IIRC jiffies are initialized so that they wrap after about 5
> minutes of uptime to reveal such bugs without forcing you to wait for
> ages just to have the counter wrap for the first time.

Yes, but if jiifie wrapping was the problem, I'd expect the contrary 
behaviour with the time_after() one hitting while the > one does not.

Rene.

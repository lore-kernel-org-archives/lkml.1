Return-Path: <linux-kernel-owner+w=401wt.eu-S1756933AbYLDNHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbYLDNHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 08:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbYLDNGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 08:06:45 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:38665 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756596AbYLDNGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 08:06:44 -0500
To: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: A question about sparse: how to use =?UTF-8?Q?=5F=5Facquires=28=29=20?=
 =?UTF-8?Q?and=20=5F=5Freleases=28=29=20correctly=20=3F?=
MIME-Version: 1.0
Date: Thu, 04 Dec 2008 14:06:36 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Alexander Shishkin <alexander.shishckin@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-sparse@vger.kernel.org
In-Reply-To: <e2e108260812040412j1f3f353bv2834750dbe914c48@mail.gmail.com> (sfid-20081204_131259_634866_966B9D93)
References: <e2e108260812021159r31eb86a1v95d2cbdf7cfdae2d@mail.gmail.com> <e2e108260812040412j1f3f353bv2834750dbe914c48@mail.gmail.com> (sfid-20081204_131259_634866_966B9D93)
Message-ID: <04bce30ee151e3f2638ef73388335cad@localhost>
User-Agent: RoundCube Webmail/0.2a
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
X-sips-origin: local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Thu, 4 Dec 2008 13:12:58 +0100, "Bart Van Assche"
<bart.vanassche@gmail.com> wrote:
> [ping]
> 
> Is there anyone who can help me with the question below ?


>> void dev_seq_stop(struct seq_file *seq, void *v)
>>        __releases(dev_base_lock)
>> {
>>        read_unlock(&dev_base_lock);
>> }
>>
>> The command "make C=2 M=net/core" produces the following output for
>> the above function (using a sparse binary built from the sparse git
>> repository, last updated on August 26, 2008):
>>
>> net/core/dev.c:2579:2: warning: context problem in 'dev_seq_stop':
>> '_read_unlock' expected different context
>> net/core/dev.c:2579:2:    context 'lock': wanted >= 1, got 0

I don't think sparse can properly handle this yet, at least not in a way
you'd expect it to. I've extended sparse to handle it, but the current git
tree has only a partial set of my changes applied, and the remaining ones
have been contested. (I still think my initial changes should be reverted
in the meantime)

>> My questions are as follows:
>> * Which argument type should be passed to __releases() -- a pointer to
>> a lock structure or the lock strucure itself ? In the header file
>> include/linux/spinlock_api_smp.h a pointer is passed to __acquires()
>> and __releases(), while other code (like the above) passes the lock
>> structure itself to the __acquires() and __releases() annotations.

sparse prett much ignores the first argument anyway, this isn't defined
yet.

>> * If the __releases() annotation is used correctly in net/core/dev.c,
>> why does sparse complain about a context problem ?

Maybe it is? I don't know off-hand.

johannes

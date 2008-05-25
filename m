Return-Path: <linux-kernel-owner+w=401wt.eu-S1761474AbYEYLyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474AbYEYLyo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 07:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756497AbYEYLyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 07:54:37 -0400
Received: from senator.holtmann.net ([87.106.208.187]:40659 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756116AbYEYLyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 07:54:36 -0400
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
Message-Id: <9995307A-E602-4A30-8900-6AEDDF7D1D8F@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Michael Buesch <mb@bu3sch.de>
In-Reply-To: <200805251149.41059.mb@bu3sch.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 13:54:32 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org> <1211707837.17151.14.camel@johannes.berg> <200805251149.41059.mb@bu3sch.de>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

>>> I explained this a couple of times. The request_firmware() is an
>>> abstract mechanism that can request a firmware file. The location of
>>> the firmware file is up to the userspace. The kernel requests a
>>> particular file and that is it. All namespacing has to be done by  
>>> the
>>> firmware helper script (nowadays udev). That the current
>>> implementation of the firmware helper maps the filename 1:1 to a  
>>> file
>>> under /lib/firmware/ just works, but doesn't have to work all the
>>> time. It is not the agreed contract between kernel and userspace.
>>
>> I don't buy this argument. I could agree if you said that the "agreed
>> contract" between the kernel and userspace is for the kernel to  
>> request
>> a firmware file /keyed by an arbitrary, null-terminated string/.
>
> I fully agree with johannes, that using / as a grouping-separator is a
> _nice_ idea and userspace must support it, regardless of the actual
> storage system it is using.
>
> Currently using a single directory for one driver really enhances  
> the way
> firmware can be handled. For example, we can have several different  
> versions
> cleanly installed in /lib/firmware. For example, on my development  
> machine
> I have
> /lib/firmware/b43
> /lib/firmware/b43-old
> /lib/firmware/b43-open
> /lib/firmware/b43legacy
> Putting all these files into plain /lib/firmware would require  
> changing the
> actual filenames and that would be a real pain. (This can be up to  
> about 100 files).

I am okay with userspace supporting namespacing with subdirectories  
and see the point why it helps, but the important here is that  
userspace must support this. It should not be done inside the kernel.

So we have to change udev to look for /lib/firmware/<driver>/ 
<filename> which perfectly fine, but the <driver> part needs to be  
derived from struct device and not from the <filename> part.

>> using "b43/<name>". What you're proposing will make firmware fail
>> *again* for all users, and we got a *LOT* of flak from all kinds of
>> stakeholders (not just the users) when firmware upgrades were  
>> required,
>> doing it again for such a petty reason is ridiculous.
>
> Yeah. I'm not going to change that. The users are going to kill us.
> Besides that, there were very good reasons to start grouping the files
> in b43 (bcm43xx didn't do it), as it simply was unmaintainable in  
> bcm43xx.

Again, I agree that we wanna have that, but putting a directory prefix  
into the driver is wrong.

Regards

Marcel


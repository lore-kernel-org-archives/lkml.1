Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbZAIVko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbZAIVko (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZAIVkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:40:36 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44168 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbZAIVkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:40:35 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4967C442.3010301@s5r6.in-berlin.de>
Date: Fri, 09 Jan 2009 22:40:18 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>
Subject: Re: post 2.6.28 regression: device_initialize() now sleeps, and	may
 fail without recovery strategy
References: <496798FE.8030900@s5r6.in-berlin.de> <20090109205633.GB19904@suse.de> <4967BE13.6070003@s5r6.in-berlin.de> <20090109213030.GA20553@suse.de>
In-Reply-To: <20090109213030.GA20553@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Fri, Jan 09, 2009 at 10:13:55PM +0100, Stefan Richter wrote:
>> get_device() and put_device() seem to be about the only things that are
>> interesting before device_add().
...
> Hm, that could be pretty simple to handle.  I'd really like to force the
> kobject itself to be dynamic, and inside the private portion of the
> device structure.  If I do that, then get_ and put_ would need to
> allocate the object if it wasn't present.  But that would mean that
> get_device could sleep, which isn't the case today

That could be a problem.

> (put_device() can always sleep, that's not an issue.)

Hmm, I wasn't aware of that, need to check my code...

...
>> Well, at least code which allocates struct device can check for failure
>> and handle it, while the allocator of dev->p can't even check.  Unless
>> you change device_initialize() to return error status and add error
>> handling all over the place...
> 
> yeah, that would be a much bigger task than I'm really pondering,
> although it probably is the correct thing to do...

If you inline struct device_private into struct device, then the problem
is gone.  But then it's a little less private then you wanted it to be
of course.
-- 
Stefan Richter
-=====-==--= ---= -=--=
http://arcgraph.de/sr/

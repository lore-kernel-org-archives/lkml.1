Return-Path: <linux-kernel-owner+w=401wt.eu-S935210AbZLPSkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935210AbZLPSkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935253AbZLPSkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:40:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935244AbZLPSkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:40:31 -0500
Message-ID: <4B29299B.5080704@redhat.com>
Date: Wed, 16 Dec 2009 19:40:27 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091130 Thunderbird/3.0
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Zdenek Kabelac <zkabelac@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] Re: dm: sysfs add empty release function to avoid
 debug	warning
References: <200912151735.nBFHZ8XP018683@hera.kernel.org> <20091216004739.GB4898@kroah.com> <4B28AC09.2000302@redhat.com> <20091216134538.GA20857@kroah.com> <4B290B95.10306@redhat.com> <20091216174632.GA12473@kroah.com>
In-Reply-To: <20091216174632.GA12473@kroah.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 06:46 PM, Greg KH wrote:
> You will find that all of these are modules, right?  That's being worked
> on still.

probably. I see that this implementation is in kernel since import to git...

What's the right solution in this particular case?
It is exactly the same situation (using embedded kobj like module handle does).

In DM, the whole problem here is that kobject is used for attribute representation
of mapped device, mapped device struct is using its own reference counting
and can dissappear before the kobject. So it must properly solve this situation.

> Again, please fix your code not to have an empty release function.  Will
> you revert this change and fix it properly?

Sure, working on it. Proper fix will replace this when ready.

Milan

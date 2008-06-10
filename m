Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYFJIMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYFJIMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 04:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753309AbYFJIMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 04:12:20 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:35756 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284AbYFJIMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 04:12:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ngzY2akFyNO4SzznXvBDv8BR44ihBK0UOy42aH0i/ZrfLCRN/Ns3FwEMMRLq/ARcRp
         Vs490alQ9O7zhVOqX3gWJildeHiSOIGpHnxFeZD180niExTaQPERy+zGa6oO2Y4wM0yD
         iF2B9F+6JcfAklmYs3Mu/SlP1CI03hG3tKqYE=
Message-ID: <43e72e890806100112u72b3706dte2fb777bacba39a3@mail.gmail.com>
Date: Tue, 10 Jun 2008 01:12:15 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Is configfs the right solution for configuration based fs?
Cc: "Ben Nizette" <bn@niasdigital.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>, "Joel Becker" <joel.becker@oracle.com>,
       "Satyam Sharma" <ssatyam@cse.iitk.ac.in>,
       "Felix Fietkau" <nbd@openwrt.org>, "Al Viro" <viro@ftp.linux.org.uk>,
       "H. Peter Anvin" <hpa@kernel.org>
In-Reply-To: <1213084880.22220.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890806081425h4e785800nc618fc1985f9809f@mail.gmail.com>
	 <1213002187.698.62.camel@johannes.berg>
	 <1213056772.4089.42.camel@moss.renham>
	 <1213084880.22220.29.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 1:01 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-06-10 at 10:12 +1000, Ben Nizette wrote:
>> On Mon, 2008-06-09 at 11:03 +0200, Johannes Berg wrote:
>>
>> > Personally, I have a few issues with this:
>> >  1) why bother with a second configuration interface that we have to
>> >     maintain, adjust, ...? if we need scriptable access, then make a
>> >     good userspace tool that is scriptable.
>>
>> What's the first one, sysfs..?  ioctl (eww..)?
>
> netlink.
>
>> >  2) string-based stuff is often messy, especially the varying attributes
>> >     like MAC addresses etc. Unless we just use binary files again, which
>> >     is not very useful again. Take, for example, the monitor flags. If
>> >     we use the same flags then nobody really knows what's up
>> >     (echo 0x3 > mntr_flags?) and if we use strings then we cannot easily
>> >     ever rename the flag while keeping ABI/API compatibility.
>>
>> Not sure I see the argument here, why would you want to change the flag
>> name?  If you decide the old name is stupid then can't you just alias
>> the old name to the new one?
>
> Sure can do, but it just adds a lot of complexity to the kernel. I don't
> see the point, it's not like you need a lot of code to build netlink
> messages. Heck, I've done it by _hand_ and used just netlink sockets.
> It's not a lot of code.

I actually agree with Johannes here, its not only complexity but also
a burden, not to mention more bloat. We get away with some flag
hackery in ath5k debug.[ch] for example to let you even use the name
of flags but to assume none of this will change over time and to leave
it to us to manage for an actual subsystem seems plainly overkill and
abuse.

>> String handling is always a bit iffy, though it has to be done
>> somewhere, either in kernel or in your "good userspace tool which is
>> scriptable".  I'd prefer to have it done once, well, in the kernel and
>> not have to ship more software than necessary.
>
> I personally prefer to put it into userspace.

This is of course subjective, I actually think your point about
leaving the complexity of string manipulation and burden on userspace
is perhaps the best argument to avoid a *complete* subsystem interface
through a configuration file system.

>> >  3) afaik configfs doesn't actually support the mkdir, ... stuff yet
>> >     that you want for virtual interfaces.
>>
>> It has all the  mkdir stuff I can think of, can you elaborate?  It
>> doesn't have the commitable object support but I just have an 'enabled'
>> attribute in there to switch the thing on and off.
>
> I don't remember the specifics, it's been a while, I guess I could be
> thinking of the commitable object support; mostly we'd want to configure
> many things in one go, even on a live object. Without disabling that
> object first, obviously.

OK we could use a fs *only* for retrieval and setting of a few
wireless configuration data then which *is tunable* without *much
complexity*. I'm thinking *standard tunable values* and *standard
stats* like those currently exported via debugfs. This could simply be
optional as well, just as debugfs is. Not even sure if configfs would
be the ideal candidate for this. Alternatively we could just not have
one too, and I'm fine with that too, but we'll just have to make great
userspace tools.

Just wanted to get an idea of what people thought and through their
experience what is best.

  Luis

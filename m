Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYHGTDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYHGTDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 15:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYHGTDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 15:03:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:63148 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbYHGTDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 15:03:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=aQN+TsKoMyT7f1u6AewMGWNRejCdrXn3nJo0bdOha0qixlHX+zZ+PjeLou2/FgRR0M
         UPo6rCBO5BcZaqRUDbckWWAJdf/E0sJ8WRQgwyts8nILXNeJ2SS/bLSATjOPwI/iM/gA
         fZybqUx0+NPVYMBMZ3od4nYkzxy1ownjjMXhE=
Message-ID: <37219a840808071203y36775d8fx5cccd653da04e1fc@mail.gmail.com>
Date: Thu, 7 Aug 2008 15:03:36 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Jean Delvare" <khali@linux-fr.org>
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
Cc: "Sam Ravnborg" <sam@ravnborg.org>, "D. Kelly" <user.kernel@gmail.com>,
       "mailing list: linux-kernel" <linux-kernel@vger.kernel.org>,
       "Linux I2C" <i2c@lm-sensors.org>
In-Reply-To: <20080807204900.1c077376@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5ab239b10807161233i6c1c4d0we01ea1b8e6ccaa5b@mail.gmail.com>
	 <20080807131357.59399ddf@hyperion.delvare>
	 <20080807183944.GA29207@uranus.ravnborg.org>
	 <20080807204900.1c077376@hyperion.delvare>
X-Google-Sender-Auth: 79e3b4a8e31d1cb4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2008 at 2:49 PM, Jean Delvare <khali@linux-fr.org> wrote:
> On Thu, 7 Aug 2008 20:39:44 +0200, Sam Ravnborg wrote:
>> >
>> > Alternatively, I am curious if our build system couldn't allow 3rd
>> > party drivers to select in-tree modules. Obviously this would require
>> > the complete kernel source tree to be available, instead of just the
>> > header and config files as is usually the case. Sam, is this possible
>> > to do that at this time? If not, is this something that could be
>> > implemented, or is this too much work for the thin benefit?
>>
>> In general I recommnd to have the full kernel source available
>> simply because we have no in-kernel solution to create the required
>> set of files to build external modules.
>>
>> And today there is no way to hook into the kernel configuration
>> for an external module. First of we cannot allow changes in
>> the build kernel module as this would destroy module versioning
>> for instance.
>>
>> And in this case you ask because you would change the kernel
>> configuration.
>>
>> And I fail to see why this stuff cannot be done inside the
>> kernel source tree. Merging new kernel updates should be absolutely
>> trivial and then the drivers are better prepared for upstream anyway.
>
> OK, thanks for the clarification.
>
> Maybe one way would be for the external module build system to copy (or
> link to) the missing driver source from the kernel tree and build it
> locally with the rest of the external drivers, if it wasn't enabled in
> the original kernel configuration and they need it. That's probably
> just a couple lines of shell script, should be pretty easy. Obviously
> this only works for kernel options which only select a given driver and
> have no side effect on the rest of the kernel. And this is more
> user-friendly than having the user check its kernel configuration and
> rebuild his/her kernel.
>
> Just a thought anyway...
>
> --
> Jean Delvare

I agree with Trent and D.Kelly

These options should be made available to the user -- We should go
with the patch that Jean posted, "Subject: i2c: Let users select
algorithm drivers manually again" -- this is a fair compromise for
both sides -- users that dont know should leave the automatic
selection enabled.  Users that know better can disable the automatic
selection and enable what they need.

The statement, "just have the external driver merged into the kernel"
is not a solution.

Removing the option to build those additional algos is a regression, IMHO

Regards,

Mike Krufky

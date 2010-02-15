Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0BOKEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 05:04:08 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:48651 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab0BOKEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 05:04:06 -0500
MIME-Version: 1.0
In-Reply-To: <520f0cf11002141822i7c77c58cl2e00305ca6890f90@mail.gmail.com>
References: <520f0cf11002110911t3f125649v73062e9851e2cfb3@mail.gmail.com>
	 <520f0cf11002140510w5c57d196n12f8036ea6085c52@mail.gmail.com>
	 <aca0ce8b1002140657l4f767635ob9b1611e4da2540b@mail.gmail.com>
	 <520f0cf11002141254y3f4536a9ta968dbaefbff58f7@mail.gmail.com>
	 <aca0ce8b1002141350o16fcfe6bn658c0ca546b38da0@mail.gmail.com>
	 <520f0cf11002141822i7c77c58cl2e00305ca6890f90@mail.gmail.com>
Date: Mon, 15 Feb 2010 01:56:45 -0800
Message-ID: <aca0ce8b1002150156sdccf9fel42a11e2fc43437e5@mail.gmail.com>
Subject: Re: [BUG]: Possibe recursive locking detected in sysfs
From: Eric Biederman <ebiederm@aristanetworks.com>
To: John Kacur <jkacur@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Tejun Heo <tj@kernel.org>, Serge Hallyn <serue@us.ibm.com>,
       "David P. Quigley" <dpquigl@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 6:22 PM, John Kacur <jkacur@redhat.com> wrote:
> On Sun, Feb 14, 2010 at 4:50 PM, Eric Biederman
> <ebiederm@aristanetworks.com> wrote:
>>> Sure, are you referring to the patch-set that begins with
>>> "[PATCH 1/6] sysfs: Serialize updates to the vfs inode"?
>>
>> Sorry no.
>>
>> http://lkml.org/lkml/2010/2/11/329
>>
>
> I applied your patch, and yes, it removed the possible recursive
> locking detected message, but everything still froze.
> I don't think I really have any good info from the crash to report.
> Your patch seems to have added the symptom of a huge number of
> BUG: key ffff880126269e40 not in .data!
> BUG: key ffff880136fc03f0 not in .data!

Those are from dynamic sysfs entries that I have not yet annoted
with sysfs_attr_init, and are generally harmless.  If you happen
to see the first one.  I would appreciate having the backtrace so I
can see about fixing it.

With respect to your problem the important point is that lockdep does
not throw a warning and disable itself.  Can you verify that?

Assuming that lockdep has not complained and disabled itself than
my patches are successful at disabling the sysfs lockdep false positives
(except those BUG: key ... not in .data messages). and the lockdep
warnings are just a coincidence in your case.

I believe the cause of your hang is somewhere else entirely.  Perhaps
a driver regression.

Eric

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbZDAIvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbZDAIvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472AbZDAIvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:51:43 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:36441 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276AbZDAIvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:51:41 -0400
X-RZG-AUTH: :LWIQcGC8af5qXkYNYt77sURZEFmV4M3TAgvB+Qeh4tE+44JfzNbYY5/NAUgO
X-RZG-CLASS-ID: mo05
Message-ID: <49D32B17.20503@ursus.ath.cx>
Date: Wed, 01 Apr 2009 10:51:35 +0200
From: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>
CC: "Andreas T.Auer" <andreas.t.auer_lkml_73537@ursus.ath.cx>,
       Alberto Gonzalez <info@gnebu.es>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Ext4 and the "30 second window of death"
References: <200903291224.21380.info@gnebu.es> <200903311452.05210.info@gnebu.es> <20090331134547.GJ13356@mit.edu> <200904010002.47077.info@gnebu.es> <49D2A5AB.1090704@ursus.ath.cx> <20090401015010.GB4529@mit.edu>
In-Reply-To: <20090401015010.GB4529@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01.04.2009 03:50 Theodore Tso wrote:
> On Wed, Apr 01, 2009 at 01:22:19AM +0200, Andreas T.Auer wrote:
>   
>> E.g. your POP3 client receives a very important mail, saves it to disk,
>> uses fsync to make sure it is out and tells the server to delete it. If
>> you are gonna delay the fsync, you will have a long window in which the
>> mail can get lost instead of a minimum window. Or are there any POP3
>> clients, which can synchronize the mail-polling with a spinning a disk?
>>     
>
> True, but consider --- this is a laptop we're talking about, right?
> What if the laptop hard drive crashes after you accidentally drop your
> laptop.  Even if you're using an SSD, what if someone steals your
> laptop.  
Well, there is always a worst case, but I had quite a lot system crashes
with unstable versions without dropping the laptop once.

> Your first mistake was using POP3.  :-)   
>   

I agree.  :-)   I am using IMAP, but a lot of people have only their
POP3 account on their only laptop.

> If all they are doing is browsing the web, and the issue is firefox's
> desire to constantly write to their home directory, the user should be
> able to say, "you know, my battery life is more important that making
> sure that every last web page I visit is saved away in some file ---
> Firefox's 'Awesome Bar' really isn't worth that much to me."
>   

AFAIK especially FF doesn't use fsync that often anymore by default. And
the user has to know this meanwhile hidden config entry
toolkit.storage.synchronous to raise the fsync level. But there are
surely enough applications that use fsync too much, and enough
applications using it not often enough.

> Of course, there is the question whether most users will be able to
> understand the risks of doing things like using POP3 and fetchmail as
> described in your scenario above.  And that's a valid question --- so
> it's worth asking whether suppressing fsync()'s really saves enough
> power to be worth it, as opposed to say, fixing applications that are
> write-happy, or choosing not to use applications which are write-happy
> when you are running on battery.
>
>   
Surely a lot of users don't understand all the risks or downsides of any
write-out policy. But there are users who do understand. For those it
would be fine, if they could define the policies for fsync and
non-fsyncs on a per-application basis (with a global default). E.g.: The
POP3-client should write synchrously with fsync, but can wait for two
minutes for non-fsynced data. Firefox should have these values and
openoffice those values etc...
But I guess the implementation effort is too high.

Andreas


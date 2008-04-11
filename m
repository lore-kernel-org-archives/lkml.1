Return-Path: <linux-kernel-owner+w=401wt.eu-S1759450AbYDKIpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759450AbYDKIpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 04:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759321AbYDKIp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 04:45:26 -0400
Received: from proxy3.bredband.net ([195.54.101.73]:45759 "EHLO
	proxy3.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801AbYDKIpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 04:45:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArNJACfC/kfVchQtPGdsb2JhbACBXYZbiQ0BAQEBMAGaKA
Message-ID: <37248.192.168.101.12.1207903522.squirrel@intranet>
In-Reply-To: <20080410224947.GA8346@sergelap.austin.ibm.com>
References: <20080409222611.GA28087@us.ibm.com>
    <20080409223231.GA28267@us.ibm.com> <871w5enmk7.fsf@basil.nowhere.org>
    <47FE073B.3060007@fr.ibm.com>
    <20080410125205.GG10019@one.firstfloor.org>
    <20080410171453.GA7023@sergelap.ibm.com>
    <49365.192.168.101.12.1207865580.squirrel@intranet>
    <20080410224947.GA8346@sergelap.austin.ibm.com>
Date: Fri, 11 Apr 2008 10:45:22 +0200 (CEST)
Subject: Re: [PATCH 1/3] change clone_flags type to u64
From: "Daniel Hokka Zakrisson" <daniel@hozac.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, "Andi Kleen" <andi@firstfloor.org>,
       "David C. Hansen" <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       "Cedric Le Goater" <clg@fr.ibm.com>,
       "Containers" <containers@lists.osdl.org>,
       "Pavel Emelyanov" <xemul@openvz.org>
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Daniel Hokka Zakrisson (daniel@hozac.com):
>> Serge E. Hallyn wrote:
>> > Quoting Andi Kleen (andi@firstfloor.org):
>> >> > I guess that was a development rationale.
>> >>
>> >> But what rationale? It just doesn't make much sense to me.
>> >>
>> >> > Most of the namespaces are in
>> >> > use in the container projects like openvz, vserver and probably
>> others
>> >> > and we needed a way to activate the code.
>> >>
>> >> You could just have added it to feature groups over time.
>> >>
>> >> >
>> >> > Not perfect I agree.
>> >> >
>> >> > > With your current strategy are you sure that even 64bit will
>> >> > > be enough in the end? For me it rather looks like you'll
>> >> > > go through those quickly too as more and more of the kernel
>> >> > > is namespaced.
>> >> >
>> >> > well, we're reaching the end. I hope ! devpts is in progress and
>> >> > mq is just waiting for a clone flag.
>> >>
>> >> Are you sure?
>> >
>> > Well for one thing we can take a somewhat different approach to new
>> > clone flags.  I.e. we could extend CLONE_NEWIPC to do mq instead of
>> > introducing a new clone flag.  The name doesn't have 'sysv' in it,
>> > and globbing all ipc resources together makes some amount of sense.
>> > Similarly has hpa+eric pointed out earlier, suka could use
>> > CLONE_NEWDEV for ptys.  If we have net, pid, ipc, devices, that's a
>> > pretty reasonable split imo.  Perhaps we tie user to devices and get
>> > rid of CLONE_NEWUSER which I suspect noone is using atm (since only
>> > Dave has run into the CONFIG_USER_SCHED problem).  Or not.  We could
>> > roll uts into net, and give CLONE_NEWUTS a deprecation period.
>>
>> Please don't. Then we'd need to re-add it in Linux-VServer to support
>> guests where network namespaces aren't used...
>
> So these are networked vservers with a different hostname?  Just
> curious, what would be a typical use for these?

Layer 3 isolation will continue to be the default for Linux-VServer.

> Anyway then I guess we won't :)  Do you have other suggestions for
> ns clone flags which ought to be combined?  Do the rest of what I
> listed make sense to you?  (If not, then I guess I'll step out of the
> way and let you and Andi fight it out :)

I think putting mq under CLONE_NEWIPC makes sense, as well as using
CLONE_NEWDEV for the ptys. If CLONE_NEWUSER is to be combined with
anything, I think it makes more sense to combine it with CLONE_NEWPID than
CLONE_NEWDEV.

> thanks,
> -serge
>

-- 
Daniel Hokka Zakrisson

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZAERmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZAERmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZAERmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:42:38 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:47599 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbZAERmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:42:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=d2xpW/0C0uhjLux4rsuuqmWtsfQ/KD2pmpSpbfmEVebFPi/hRVahb/melh3otZ7k/H
         Egnw+CPGBZL2hTzc2nEVQd9UL1K+8v3JIQI00aNggY7fGSbEHu+arkrjFxUnjCURdiYT
         uYvdjQmXI+kpruGQF/gV1W3s/9U2UTnVWlNFc=
Message-ID: <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
Date: Mon, 5 Jan 2009 11:42:35 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: david@lang.hm
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "Nick Andrew" <nick@nick-andrew.net>,
       "David Newall" <davidn@davidnewall.com>,
       "Kyle Moffett" <kyle@moffetthome.net>,
       "Ben Goodger" <goodgerster@gmail.com>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org,
       "Jeffrey J. Kosowsky" <jeff@kosowsky.org>,
       MentalMooMan <slashdot@jameshallam.info>,
       "Travis Crump" <pretzalz@techhouse.org>, burdell@iruntheinter.net,
       mills@udel.edu, "Brian Haberman" <brian@innovationslab.net>,
       "Karen O'Donoghue" <karen.odonoghue@navy.mil>, ntpwg@lists.ntp.isc.org
In-Reply-To: <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495F0672.6020708@davidnewall.com>
	 <4960897D.5030603@davidnewall.com>
	 <alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
	 <4961432A.80509@davidnewall.com>
	 <alpine.DEB.1.10.0901041628100.25545@asgard.lang.hm>
	 <49614835.7000505@davidnewall.com>
	 <3ae3aa420901042148o1c96985dube8e03085c997a07@mail.gmail.com>
	 <20090105143335.GC18055@mail.local.tull.net>
	 <3ae3aa420901050808r100e533fo5f88edfbb5f0747a@mail.gmail.com>
	 <alpine.DEB.1.10.0901050949560.27641@asgard.lang.hm>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/5  <david@lang.hm>:
> On Mon, 5 Jan 2009, Linas Vepstas wrote:
>
>>> Arguably the kernel's responsibility should be to keep track of the
>>> most fundamental representation of time possible for a machine (that's
>>> probably TAI) and it is a userspace responsibility to map from that
>>> value to other time standards including UTC,
>>
>> Yes, this really does seem like the right solution.
>>
>>> using control files
>>> which are updated as leap seconds are declared.
>>
>> Lets be clear on what "control files" means.  This does
>> *NOT* mean some config file shipped by some distro
>> for some package. That would be a horrid solution.
>> People don't install updates, patches, etc.  Distros
>> ship them late, or never, if the distro is old enough.
>>
>> A more appropriate solution would be to have
>> either the kernel or ntpd track the leap seconds
>> automatically.  First, the ntp protocol already provides
>> the needed notification of a leap second to anyone
>> who cares about it (i.e. there is no point in getting a
>> Linux distro involved in this -- a distribution mechanism
>> already exists, and works *better* than having a distro
>> do it).
>
> I disagree with this. NTP will only know about leap seconds if it was
> running and connected to a server that advertised the leap seconds during
> that month.
>
> for example, if you installed a new server today, how would it ever know
> that there was a leap second a couple of days ago?

OK, good point.  Unless your distro was less
than a few days old (unlikely), you are faced with the
same problem.  Sure, eventually, the distro will publish
an update (which will add to the existing list of 36 leap
seconds -- which is needed in any case, since no one
has a server that's been up since 1958),  but this is
unlikely to happen during this install window.

The long term solution would be write an RFC to extend
NTP to also provide TAI information -- e.g. to add a
message that indicates the current leap-second offset
between UTC and TAI.

--linas

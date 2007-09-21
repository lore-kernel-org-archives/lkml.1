Return-Path: <linux-kernel-owner+w=401wt.eu-S1760084AbXIUOSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760084AbXIUOSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbXIUOSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:18:45 -0400
Received: from mga03.intel.com ([143.182.124.21]:60695 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758568AbXIUOSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:18:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,284,1186383600"; 
   d="scan'208";a="283666027"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Message codes (Re: [Announce] Linux-tiny project revival)
Date: Fri, 21 Sep 2007 07:18:40 -0700
Message-ID: <5389061B65D50446B1783B97DFDB392D07126ACB@orsmsx411.amr.corp.intel.com>
In-Reply-To: <E1IYWps-0006fQ-83@flower>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Message codes (Re: [Announce] Linux-tiny project revival)
thread-index: Acf76DxeAS7jx7toS8iUvDPq9gluCgAcLOKQ
References: <46F1645D.9050406@am.sony.com> <200709201538.43093.rob@landley.net> <20070920195844.GA1805@martell.zuzino.mipt.ru> <200709201702.08126.rob@landley.net> <5389061B65D50446B1783B97DFDB392D07126574@orsmsx411.amr.corp.intel.com> <E1IYWps-0006fQ-83@flower>
From: "Gross, Mark" <mark.gross@intel.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Cc: "Rob Landley" <rob@landley.net>, "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Michael Opdenacker" <michael@free-electrons.com>,
       <linux-tiny@selenic.com>,
       "CE Linux Developers List" <celinux-dev@tree.celinuxforum.org>,
       "linux kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 21 Sep 2007 14:18:40.0746 (UTC) FILETIME=[4F1634A0:01C7FC5A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Oleg Verych [mailto:olecom@flower.upol.cz]
>Sent: Thursday, September 20, 2007 5:58 PM
>To: Gross, Mark
>Cc: Rob Landley; Alexey Dobriyan; Michael Opdenacker; linux-
>tiny@selenic.com; CE Linux Developers List; linux kernel
>Subject: Message codes (Re: [Announce] Linux-tiny project revival)
>
>* Thu, 20 Sep 2007 15:15:47 -0700
>* X-MimeOLE: Produced By Microsoft Exchange V6.5
>[]
>>>*Shrug*.
>>>
>>>My problem is that switching off printk is the single biggest bloat
>> cutter
>>>in
>>>the kernel, yet it makes the resulting system very hard to support.
It
>>>combines a big upside with a big downside, and I'd like something in
>>>between.
>>
>> What about getting even more hard core?
>>
>> Use compiler tricks to remove ALL the static printk string from the
>> kernel and replace the printk with something that outputs an decimal
>> index followed by tuples, of zero to N, hex-strings on a single line.
>
>Not all, but critical info, that must exist in human-readable form of
>course.

I disagree.  For a production product the you want minimal information
to reduce the communication bandwidth required between the remote
customer and the support organization.

In fact there is a good argument that you don't what the remote customer
to know enough to start guessing.  In the support stage of a products
life cycle you really don't want guessing or fudging of information
based on guessing.  Keeping the output cryptic and short will avoid
these things.  (That really does happen and it cost a lot in support
engineering time)

>
>> Then have the syslogd or some other utility take this cryptic output
and
>> convolve it with a table (created at compile time) to re-create what
>> would have been dumped to the sys-log ring buffer.  This way you
strip
>> out most of the static text from the kernel and yet can still
re-create
>> the kernlog output.
>>
>> At least as a post processing operation....
>
>Sure, but a little problem is, that many kernel developers do C
(mostly)
>and Perl (occasionally), i.e. very few do non-trivial userspace (even
>userspace do too much C and Perl sometimes [:
><http://thread.gmane.org/gmane.comp.lib.glibc.alpha/12739>)
>

Oh poo.  Kernel programmers can use user mode tools and write them too,
and I *know* even I could write such a post processing program to take a
somewhat compressed and cryptic output and generate what would have been
created in the syslog used.  (in python)

>> Is this an old idea?  I'm guessing this has been at least proposed
>> before....
>
>Seriously. When in the Windows there are only messages like:
>
>    "Error (Code:0x00002012)".

Now it's been ~8 years since I did any serious windows work, but if I
recall correctly ALL THE FRICKING TIME!!! When was the last time you've
seen a bug check on windows?  This is about all you get.

>
>In the Linux... well, embedded targets, this can be turned in a very
>efficient thing by means of userspace. On other setups this can be nice
>and pleasant one, with yet another L10N project, recently promoted by
>README translations. But,,, see problem above.
>____

>From you comments I'm not sure you are for or against this idea.

--mgross

Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbYDAJ3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbYDAJ3t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 05:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbYDAJ3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 05:29:41 -0400
Received: from smtp.nokia.com ([192.100.105.134]:19750 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbYDAJ3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 05:29:40 -0400
Message-ID: <47F1FF98.9020809@nokia.com>
Date: Tue, 01 Apr 2008 12:25:44 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Artem Bityutskiy <dedekind@yandex.ru>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>	 <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com>	 <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com>	 <47F1F7A6.5020105@yandex.ru> <84144f020804010215o209fbed8gf629dc6557fcd091@mail.gmail.com>
In-Reply-To: <84144f020804010215o209fbed8gf629dc6557fcd091@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 09:29:34.0886 (UTC) FILETIME=[E5DFC460:01C893DA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Tue, Apr 1, 2008 at 11:51 AM, Artem Bityutskiy <dedekind@yandex.ru> wrote:
>>  Well, its just more convenient for us. If I know the bug is somewhere in
>>  the journal, I enable the journal messages - less flooding. We may
>>  lessen the amount, but it is still handy to have some classes of
>>  prints separate.
> 
> Yeah, perhaps that's a sign that you're doing it wrong? You currently
> have 430 separate debug printks sprinkled around in UBIFS. 
JFFS2 has the similar thing. I myself fixed bugs just by asking people
enabling them and sending the log. Very useful. This is why we also added
them to UBIFS - good JFFS2 experience.

> The way to
> reduce that is to move as much logging as possible higher up the call
> chain and dump as much information as you can there.
Yeah, this is what the dbg_gen doing :-) But often we need messages from
lower layers, why not? I agree we should lessen the amount of prints, but
I still do not get it what is your argument against them the shiny prints
which we may compile in when we want to debug :)

> That's what
> ext2_error() does, for example. So I'm not opposed to a ubifs_error()
> or ubifs_warning() even if that's used in a controlled fashion. The
> way you do debugging checks now is totally ad hoc and IMHO not
> acceptable to the mainline kernel.
Why? What is wrong with this? As I said, we found it very useful in JFFS2,
because I has been working with JFFS2 for _long_ time. Talk to David
Woodhouse and ask how many times that made him fix a bug just by having
people send a log. Why do you want to prevent us from having this?

> And like I said, if you need _tracing_ you might want to look at
> Ingo's ftrace or some other similar tracing infrastructure and use
> that. The upside of it is that you can basically have it enabled at
> run-time too.
This alternative is not really acceptable.  We want to have only _few_
debugging things always enabled, and have other things always compiled
out and compiled in only when hunting a problem.

> On Tue, Apr 1, 2008 at 11:51 AM, Artem Bityutskiy <dedekind@yandex.ru> wrote:
>>  Some of the checks are very heavy-weight. For example, the tree checking
>>  functions scan the whole TNC/LPT B-tree, which means they read it from
>>  flash, they check CRC, and they make sure the tree is consistent and
>>  has sane data. They are very useful when hunting bugs, but they are too
>>  slow to be always enabled.
> 
> So perhaps you could just separate those heavy-weight options and have
> all others under CONFIG_UBIFS_DEBUG?

We can if we have to. But these checks often affect the FS behavior and
sometimes make bugs go away and become unreproducible. Especially locking
problems. This is why we want to be able to enabling them separately.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

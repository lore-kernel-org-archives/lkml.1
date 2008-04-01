Return-Path: <linux-kernel-owner+w=401wt.eu-S1757763AbYDAKb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757763AbYDAKb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 06:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYDAKbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 06:31:18 -0400
Received: from smtp.nokia.com ([192.100.122.233]:56475 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbYDAKbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 06:31:17 -0400
Message-ID: <47F20DEE.7090105@nokia.com>
Date: Tue, 01 Apr 2008 13:26:54 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Artem Bityutskiy <dedekind@yandex.ru>, LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>	 <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com>	 <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com>	 <47F1F7A6.5020105@yandex.ru>	 <84144f020804010215o209fbed8gf629dc6557fcd091@mail.gmail.com>	 <47F1FF98.9020809@nokia.com> <84144f020804010304w7057a68cqa5b9a7a5364b9489@mail.gmail.com>
In-Reply-To: <84144f020804010304w7057a68cqa5b9a7a5364b9489@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 01 Apr 2008 10:30:46.0089 (UTC) FILETIME=[7214E390:01C893E3]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Tue, Apr 1, 2008 at 12:25 PM, Artem Bityutskiy
> <Artem.Bityutskiy@nokia.com> wrote:
>> JFFS2 has the similar thing. I myself fixed bugs just by asking people
>> enabling them and sending the log. Very useful. This is why we also added
>> them to UBIFS - good JFFS2 experience.
>>
>> Why? What is wrong with this? As I said, we found it very useful in JFFS2,
>> because I has been working with JFFS2 for _long_ time. Talk to David
>> Woodhouse and ask how many times that made him fix a bug just by having
>> people send a log. Why do you want to prevent us from having this?
> 
> First and foremost, JFFS2 uses BUG_ON and doesn't invent it's own
> assert.
True. But it has checking code which may be enabled or disable.
An assert is just a special case of this. You do not say why
it hurts. For me it looks like your personal taste.

We well try to lessen the amount of asserts.

> Furthermore, the debug tracing code prints out human-readable
> text in well-thought of places.
The same is with UBIFS. We will make the amount of messages less,
and the granularity less, that it would be more "well-thought".

> But there simply is no
> comparison between JFFS2 and UBIFS debug logging code. The former is
> cleanly structured whereas yours looks to be totally ad hoc.
What exactly you think is not-structured, we'll fix this.

> But perhaps the problem will go away after you inject some sanity to
> stuff like this:
> 
> fs/ubifs/dir.c: dbg_gen("dent '%.*s' to ino %lu (nlink %d) in dir ino %lu",
> fs/ubifs/dir.c: dbg_gen("dent '%.*s' from ino %lu (nlink %d) in dir ino %lu",
> fs/ubifs/dir.c: dbg_gen("directory '%.*s', ino %lu in dir ino %lu",
> dentry->d_name.len,
> fs/ubifs/dir.c: dbg_gen("dent '%.*s', mode %#x in dir ino %lu",
> fs/ubifs/dir.c: dbg_gen("dent '%.*s' in dir ino %lu",
This means that when debugging is enabled, you'll have prints like:
UBIFS DBG (pid 28398): ubifs_create: dent 'file', mode 0x81a4 in dir ino 1
or
UBIFS DBG (pid 28398): ubifs_setattr: ino 65, ia_valid 0x70

We tried to keep messages shorter because logging takes time and long
messages make it slower to debug the code.

Anyway, we will lessen and re-view this, and make it nicer.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

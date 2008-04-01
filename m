Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbYDAKEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYDAKEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 06:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756211AbYDAKEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 06:04:14 -0400
Received: from rv-out-0910.google.com ([209.85.198.185]:56507 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbYDAKEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 06:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=gCGeTTx93gPXE1oVyCDUO5yMAOjor4t2yOkwmeSzJst7lTNUicUuzS3HAWsAn4sTcqj5sFT/U2jBebgwvLAe59OPeObdWTqJ1FyxqZPSEI5FRNBfpvuYW/IIWts73nmZFuSjpC9UqS9DsxDdz4ELciiUU9sehMROi+NR19YI6WY=
Message-ID: <84144f020804010304w7057a68cqa5b9a7a5364b9489@mail.gmail.com>
Date: Tue, 1 Apr 2008 13:04:11 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: Artem.Bityutskiy@nokia.com
Subject: Re: [RFC PATCH 26/26] UBIFS: include FS to compilation
Cc: "Artem Bityutskiy" <dedekind@yandex.ru>,
       LKML <linux-kernel@vger.kernel.org>,
       "Adrian Hunter" <ext-adrian.hunter@nokia.com>,
       "David Woodhouse" <dwmw2@infradead.org>
In-Reply-To: <47F1FF98.9020809@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com>
	 <1206629746-4298-27-git-send-email-Artem.Bityutskiy@nokia.com>
	 <84144f020804010039n47133bd3l63f02258a2670e72@mail.gmail.com>
	 <47F1F7A6.5020105@yandex.ru>
	 <84144f020804010215o209fbed8gf629dc6557fcd091@mail.gmail.com>
	 <47F1FF98.9020809@nokia.com>
X-Google-Sender-Auth: 2fff74b4f75ea259
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

Pekka Enberg wrote:
> > Yeah, perhaps that's a sign that you're doing it wrong? You currently
> > have 430 separate debug printks sprinkled around in UBIFS.

On Tue, Apr 1, 2008 at 12:25 PM, Artem Bityutskiy
<Artem.Bityutskiy@nokia.com> wrote:
> JFFS2 has the similar thing. I myself fixed bugs just by asking people
> enabling them and sending the log. Very useful. This is why we also added
> them to UBIFS - good JFFS2 experience.
>
> Why? What is wrong with this? As I said, we found it very useful in JFFS2,
> because I has been working with JFFS2 for _long_ time. Talk to David
> Woodhouse and ask how many times that made him fix a bug just by having
> people send a log. Why do you want to prevent us from having this?

First and foremost, JFFS2 uses BUG_ON and doesn't invent it's own
assert. Furthermore, the debug tracing code prints out human-readable
text in well-thought of places. It's looks bit excessive to me and I
don't see a good reason why the different logging levels are not
run-time configurable (if you're going to invent a logging
infrastructure, why not do it properly). But there simply is no
comparison between JFFS2 and UBIFS debug logging code. The former is
cleanly structured whereas yours looks to be totally ad hoc.

But perhaps the problem will go away after you inject some sanity to
stuff like this:

fs/ubifs/dir.c: dbg_gen("dent '%.*s' to ino %lu (nlink %d) in dir ino %lu",
fs/ubifs/dir.c: dbg_gen("dent '%.*s' from ino %lu (nlink %d) in dir ino %lu",
fs/ubifs/dir.c: dbg_gen("directory '%.*s', ino %lu in dir ino %lu",
dentry->d_name.len,
fs/ubifs/dir.c: dbg_gen("dent '%.*s', mode %#x in dir ino %lu",
fs/ubifs/dir.c: dbg_gen("dent '%.*s' in dir ino %lu",

                        Pekka

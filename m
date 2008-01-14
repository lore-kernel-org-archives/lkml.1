Return-Path: <linux-kernel-owner+w=401wt.eu-S1755168AbYANIdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168AbYANIdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbYANIdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:33:14 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:2139
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751465AbYANIdN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:33:13 -0500
Message-Id: <478B2C6F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 14 Jan 2008 08:33:35 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] __cpuinitconst and __devinitconst
References: <47873D11.76E4.0078.0@novell.com>
 <20080111194428.GB29189@uranus.ravnborg.org>
 <20080112205635.GA6059@uranus.ravnborg.org>
 <20080113073024.GA30120@uranus.ravnborg.org>
 <20080113214204.GB2205@uranus.ravnborg.org>
In-Reply-To: <20080113214204.GB2205@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Sam Ravnborg <sam@ravnborg.org> 13.01.08 22:42 >>>
>> And I found another small buglet too. I hope to post a complete
>> solution later today.
>
>The modpost bits turned out to take longer than expected so 
>they are not done yet. The problem was the modpost structure
>were not prepared for adding such additional chacks.
>So I reworked those bits and the patch has been sent out for review.
>
>What follows here is the changes for init.h + all linker scripts
>to show the idea.
>
>Next step is to beat modpost in shape and to post this on linux-arch.
>
>Note - in -mm there are changes to init.h so the logic
>to decide type of __meminit notation is much simpler.

Yes, I certainly like this concept. What I would have wanted in that patch,
though, is that the read-only data would right away be included in
RODATA() rather than being put in DATA_DATA. Also, to shorten the
names a little, how about .{cpu,mem,dev}init.rodata?

The one thing that I'm not sure is really consistent yet wrt. the
constification is that now you need to write e.g.

static const char __cpuinitcdata example[];

and (accidentally) omitting the 'const' (as it's really an apparently
redundant thing now) as in

static char __cpuinitcdata example[];

will cause section type conflicts (at the compiler or linker level). I
therefore think that the 'const' should really be part of the
__{cpu,mem,dev}cdata definitions (requiring the attribute to be
placed properly, namely placement at the end of a declaration as
is possible with __{cpu,mem,dev}initdata is then not an option here).

Jan


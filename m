Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbYANJZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbYANJZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 04:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYANJZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 04:25:35 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:5224
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753679AbYANJZe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 04:25:34 -0500
Message-Id: <478B38B2.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Mon, 14 Jan 2008 09:25:54 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] __cpuinitconst and __devinitconst
References: <47873D11.76E4.0078.0@novell.com>
 <20080111194428.GB29189@uranus.ravnborg.org>
 <20080112205635.GA6059@uranus.ravnborg.org>
 <20080113073024.GA30120@uranus.ravnborg.org>
 <20080113214204.GB2205@uranus.ravnborg.org>
 <478B2C6F.76E4.0078.0@novell.com>
 <20080114091728.GA6674@uranus.ravnborg.org>
In-Reply-To: <20080114091728.GA6674@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The one thing that I'm not sure is really consistent yet wrt. the
>> constification is that now you need to write e.g.
>> 
>> static const char __cpuinitcdata example[];
>> 
>> and (accidentally) omitting the 'const' (as it's really an apparently
>> redundant thing now) as in
>> 
>> static char __cpuinitcdata example[];
>> 
>> will cause section type conflicts (at the compiler or linker level). I
>> therefore think that the 'const' should really be part of the
>> __{cpu,mem,dev}cdata definitions (requiring the attribute to be
>> placed properly, namely placement at the end of a declaration as
>> is possible with __{cpu,mem,dev}initdata is then not an option here).
>
>I need to play a little with this before I make up my mind.
>I do not like the concpet of hiding the const too much - it will
>be non-obvious why the compiler complains if the only thing that
>distingush const from non-const is a small capital 'c' within
>__cpucinitdata (versus __cpuinitdata).

That's the main reason I preferred __{cpu,mem,dev}initconst, as it
makes it more obvious that the declared thing is 'const'.

Jan


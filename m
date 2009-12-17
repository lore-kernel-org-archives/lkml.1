Return-Path: <linux-kernel-owner+w=401wt.eu-S1751558AbZLQFO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbZLQFO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZLQFO1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:14:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbZLQFO0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:14:26 -0500
Message-ID: <4B29BEC4.4070801@redhat.com>
Date: Thu, 17 Dec 2009 00:16:52 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Isaacson <adi@vmware.com>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org> <20091217011932.GT14381@ZenIV.linux.org.uk> <4B29A8F3.3090306@redhat.com> <20091217043021.GV14381@ZenIV.linux.org.uk>
In-Reply-To: <20091217043021.GV14381@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Al Viro wrote:
> On Wed, Dec 16, 2009 at 10:43:47PM -0500, Masami Hiramatsu wrote:
>> Al Viro wrote:
>>> On Wed, Dec 16, 2009 at 03:56:17PM -0800, Andrew Isaacson wrote:
>>>> With CONFIG_KPROBES=y on Ubuntu 9.10 x86_64 default install, I get the
>>>> following:
>>>>
>>>> Error: Your awk doesn't support charactor-class.
>>>> Please try to use gawk.
>>>
>>> Aside of the incorrect suggestion (you need not just gawk, you need that
>>> thing installed as awk), the use of GNUisms in there is actually pointless
>>> since encoding is bloody fixed.
>>
>> Hmm, maybe "POSIX awk" will be a better suggestion, isn't it?
> 
> Not really.
> 
> Note that meaning of [:alpha:] depends on locale, and you are working
> with fixed input, in fixed encoding.  So you *already* have a dependency
> on locale and it's no better or worse way to express the set than A-Za-z
> is.  With LANG=C both describe the set you are after; in other locales
> neither is guaranteed to.  And having it set by caller of your script
> is trivial.
> 
> IOW, you are actually misusing the language feature and while it's easy
> to fix, the same fix will remove any benefits compared to universally
> available alternative language feature.

Ah, I see:)

I think that this is not so big issue as making new language in the kernel.
(wow, if someone wants to do that, I don't dare to stop him :) )
If just typing less than 100 characters can fix it, I'd like to do it; e.g.

Ualpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
Lalpha = "abcdefghijklmnopqrstuvwxyz"
alpha = Ualpha Lalpha
digit = "0123456789"
alnum = alpha digit

and replace character classes with it. ("[[:alpha:]]"->"[" alpha "]")

That's so easy, isn't that? :-)

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


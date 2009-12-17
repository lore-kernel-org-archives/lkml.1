Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbZLQFUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbZLQFUN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 00:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbZLQFUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 00:20:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751472AbZLQFUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 00:20:05 -0500
Message-ID: <4B29BFF1.6090304@redhat.com>
Date: Thu, 17 Dec 2009 00:21:53 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Roland Dreier <rdreier@cisco.com>, Andrew Isaacson <adi@vmware.com>,
       Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org>	<adabphy750b.fsf@roland-alpha.cisco.com> <4B299AB5.7020109@zytor.com> <ada7hsm6y3g.fsf@roland-alpha.cisco.com> <4B29BC90.9090204@zytor.com>
In-Reply-To: <4B29BC90.9090204@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> On 12/16/2009 08:09 PM, Roland Dreier wrote:
>>
>>  > > Is there any reason not to apply the patch below, to allow more awk
>>  > > implementations to be used?  After all, it's not like we're going to put
>>  > > non-ASCII characters into the map file...
>>
>>  > I guess the question is if it will break under any other circumstances,
>>  > but I guess we can find those when we get to them.
>>
>> I should have mentioned it, but with the current Debian testing version
>> (mawk 1.3.3-15) and my patch, I get a byte-for-byte identical
>> inat-tables.c to what I get with the unpatched kernel and gawk
>> 1:3.1.6.dfsg-4.
>>
>> I'm not sure how likely all this is to change in the future, but it's
>> hard for me to see a sane reason why eg [:lower:] and a-z would be
>> different for this use.
>>
> 
> If LC_COLL != C they can be.  The solution would be to force LC_COLL=C.

Hmm, it's complicated :(.  Peter, Roland, I don't want to be annoyed
by those environmental variables. If my last suggestion is acceptable,
could you do as below on your patch :)?

> Ualpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
> Lalpha = "abcdefghijklmnopqrstuvwxyz"
> alpha = Ualpha Lalpha
> digit = "0123456789"
> alnum = alpha digit
> 
> and replace character classes with it. ("[[:alpha:]]"->"[" alpha "]")

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


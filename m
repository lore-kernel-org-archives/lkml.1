Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYIBO3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYIBO3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbYIBO3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:29:37 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:40842 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbYIBO3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:29:36 -0400
Message-ID: <48BD4DCE.9020507@s5r6.in-berlin.de>
Date: Tue, 02 Sep 2008 16:29:34 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Mike Isely <isely@pobox.com>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PULL]	http://linuxtv.org/hg/~mcisely/pvrusb2
References: <Pine.LNX.4.64.0808312020060.16986@cnc.isely.net>	<20080902061821.4df5cba4@mchehab.chehab.org> <Pine.LNX.4.64.0809020815060.16986@cnc.isely.net> <48BD3FCC.2030206@linuxtv.org>
In-Reply-To: <48BD3FCC.2030206@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Krufky wrote:
> Mike Isely wrote:
>> On Tue, 2 Sep 2008, Mauro Carvalho Chehab wrote:
>>> Please: don't do tricks like this to cheat with checkpatch.pl. The error is
>>> there to point to a Coding Style violation.
>>>
>>> +	if (ret < 0) {
>>> +		/* Keep checkpatch.pl quiet */
>>> +		return ret;
>>> +	}
[...]
>> Forcing this style:
>>
>> 	if (a)
>> 		b;
>>
>> As opposed to the much safer
>>
>> 	if (a) {
>> 		b;
>> 	}
>>
>> is a huge mistake.  Both generate the same code; the second form is 
>> robust against someone later inserting a printk
[...]

If you need this kind of safety measures against errors in future code
changes, could it be that you have some general QA problems?

(However, why waste time arguing over braces or not?)

> I understand that kernel codingstyle forbids single line bracketing,

CodingStyle currently says that braces are not to be used there, *but*
it does not give any explanation for it (other than hinting that the
braces are unnecessary).

It is important to remember that many rules in CodingStyle are _not_
hard rules but just widely (though not universally) accepted
conventions.  And more importantly, checkpatch is even less
authoritative than CodingStyle.  It only gives hints and
recommendations, even if it reports an "error".

If a driver author/maintainer has been using
	if (a) {
		b;
	}
consistently in his driver all the time, why not leave it this way?  It
arguably does not hurt readability.

> but
> codingstyle does not forbid adding comments anywhere in the c source.

Reread the section on commenting.  One very important rule in the Linux
kernel coding style is that we comment sparingly.  We comment with the
goal to keep code readable.

This /* I'll trick checkpatch */ comment is only distracting the reader.
It serves no purpose whatsoever, except to manipulate the output of some
random code submission checking tool.

> Mike added a comment, to create a compromise between kernel codingstyle
> and his own.

The coding style does not contain a rule that says "you may use braces
around single statement blocks if you add a silly, useless, distracting
comment as compensation, because coding style is all about what
checkpatch reports, not about writing well maintainable code".

> This code comes from Mike's svn repository, where he uses
> #ifdefs and various other compat code within his own build environment
> to stay compatible with the v4l-dvb hg tree and the upstream kernel alike.
> 
> Mike is using brackets to ensure that all builds work properly, and to
> ensure that there is no breakage when creating patches for mercurial, or
> when building directly from his svn repository.

Doesn't matter for a mainline release branch.

> There is nothing wrong with the comments that Mike has in his code --
> you should not hold up his merge request for that reason.

There /is/ something wrong with the comment, see above.

> Not only is this another example of checkpatch.pl thwarting development
[...]

With this I agree.
-- 
Stefan Richter
-=====-==--- =--= ---=-
http://arcgraph.de/sr/

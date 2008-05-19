Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbYESHmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbYESHmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 03:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbYESHmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 03:42:24 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:18272 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbYESHmX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 03:42:23 -0400
Message-Id: <48314B95.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Mon, 19 May 2008 08:42:45 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "linux-kbuild" <linux-kbuild@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] move link of vmlinux from Makefile to a script
References: <482DCD89.76E4.0078.0@novell.com>
 <20080517125204.GA19741@uranus.ravnborg.org>
 <20080518185219.GA777@uranus.ravnborg.org>
In-Reply-To: <20080518185219.GA777@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Sam Ravnborg <sam@ravnborg.org> 18.05.08 20:52 >>>
>> 
>> I have several times been tempted to move it all to a shell script.
>> What has prevented me to do so has only been:
>> 1) that um has some subtle requirement and therefore redefine the
>>    vmlinux link
>> 2) that last time I reworked this stuff Andrew could not boot one
>>    of his systems and I never figured out why
>> 3) lack of time..
>> 
>> But if someone comes up with a patch that moves all this stuff out
>> of the top-level Makefile I am all open for it.
>
>I gave it a quick try. This is first try and comments are welcome.
>It does not address the um issue - but I think that is doable
>with an additional enviroment variable.
>
>The conditionals around KALLSYMS may be simplified - I just did
>not try to do so.

What I fail to see is how the multi-stage (necessary even without
CONFIG_KALLSYMS_EXTRA_PASS) kallsyms linking is now happening.

>What I like with the patch below is that it is 100 times more
>readable than the Makefile stuff.

Fully agree, and hence I'd favor this for .27 over the simple version
handling fix (which I'd hope to see in .26, and maybe even .25.x).

>The drawback are that we either link or not - we cannot restart
>from the middle of the link. But that it not a real issue.
>
>This patch futhermore remove a debug target to assist in
>kallysms issues - I have not seen it used for a long time
>now.

Is this what I referred to above? If so, I don't think these are just
debug targets...

>And I was also considering removing the extra kallsyms
>pass as I dunnot how usefull it is and for an allyesconfig
>build it take too much time.

I'd vote for it, but would of course think that whoever introduced it
should voice his opinion.

>This patch includes your version simplifactions too allthough
>that is not obvious.

Thanks, Jan


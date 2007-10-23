Return-Path: <linux-kernel-owner+w=401wt.eu-S1753179AbXJWObl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbXJWObl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 10:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbXJWObb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 10:31:31 -0400
Received: from gw.goop.org ([64.81.55.164]:51873 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751862AbXJWObb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 10:31:31 -0400
Message-ID: <471E05C0.4010005@goop.org>
Date: Tue, 23 Oct 2007 07:31:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, Al Viro <viro@ftp.linux.org.uk>,
       WANG Cong <xiyou.wangcong@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       Nix <nix@esperi.org.uk>, Jeff Dike <jdike@addtoit.com>,
       Paolo Giarrusso <p.giarrusso@gmail.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in	2.6.23-final.
References: <20071022122504.GL2998@hacking> <20071022124322.GB8181@ftp.linux.org.uk> <20071022124551.GA7438@elte.hu> <471D2ECC.6090209@goop.org> <20071022231927.GA30814@elte.hu> <471D389E.40609@goop.org> <20071023084546.GA17007@elte.hu> <p73wste7zy5.fsf@bingen.suse.de> <20071023131009.GA32298@elte.hu> <p73sl427wvu.fsf@bingen.suse.de> <20071023142006.GA9961@elte.hu>
In-Reply-To: <20071023142006.GA9961@elte.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
>
>   
>>>> You should rename it then to "asmcall" or something.
>>>>         
>>> if then that should be a separate renaming patch.
>>>       
>> Well you're asking for the ugly hacks for out of tree code.  [...]
>>     
>
> nice word-bending there. I'm asking for pre-existing annotations to 
> survive. It hurts you _nothing_ and it was a world of pain for us to 
> recover those lost annotations. Anyway, if Jeremy does not object to the 
> patch

I don't have any objections to the idea of the patch, but I'm still
concerned about the practical aspects of it.  Maintaining these kinds of
annotations is hard/fragile/etc when the compiler doesn't warn when you
get it wrong, and only a very specific use-case will reveal the problem
(and do so in a fairly obscure way).

>  we'll push it in and then rename fastcall to asmcall. Much ado 
> about nothing.

Hm, "asmcall" is confusingly close to "asmlinkage" - and they have
exactly the same intent (can be called from asm), but with exactly the
opposite effect.  How about something which actually says what we mean. 
How about just "regparm"?

    J

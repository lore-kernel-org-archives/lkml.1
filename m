Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbYDNBuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbYDNBuv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 21:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754353AbYDNBuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 21:50:39 -0400
Received: from mail8.dotsterhost.com ([66.11.233.1]:54489 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753457AbYDNBui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 21:50:38 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Apr 2008 21:50:37 EDT
Message-ID: <4802B63F.2010804@crispincowan.com>
Date: Sun, 13 Apr 2008 18:41:19 -0700
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, paul.moore@hp.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
References: <20080404122242.867070732@I-love.SAKURA.ne.jp> <20080404122408.986477936@I-love.SAKURA.ne.jp> <200804071140.59247.paul.moore@hp.com> <47FC8052.9070409@nttdata.co.jp> <20080409131151.GK11962@parisc-linux.org> <200804112312.HGE69734.LFOOHQOSFFMJtV@I-love.SAKURA.ne.jp> <20080411143013.GB11962@parisc-linux.org>
In-Reply-To: <20080411143013.GB11962@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Fri, Apr 11, 2008 at 11:12:27PM +0900, Tetsuo Handa wrote:
>   
>> If write access is denied because of a rule "No modifications to /etc/passwd",
>> a rule "Allow modifications to /tmp/passwd" can no longer be enforced after
>> "mount --bind /etc/ /tmp/" or "mount --bind /etc/passwd /tmp/passwd" or
>> "mv /etc/passwd /tmp/passwd" or "ln /etc/passwd /tmp/passwd" is done.
>>     
> That's a fundamental limitation of pathname-based security though.
> If the same file exists in two places, you have to resolve the question
> of which rule overrides the other.
>
> In my role as a sysadmin, I would consider it a flaw if someone could
> edit a file I'd marked uneditable -- simply by creating a hard-link to it.
> If we look at existing systems, such as the immutable bit, those apply to
> inodes, not to paths, so they can't be evaded.  If a system such as TOMOYA
> allows evasion this easily, then it doesn't seem like an improvement.
>   
You are discussing a straw-man, because AppArmor (and I think TOMOYO) do 
not operate that way.

It is not, and never has been, "mark /etc/passwd not writable". Please 
delete this broken concept from the discussion.

Rather, it is "can write to /tmp/ntpd/*". You *grant* permissions. You 
do *not* throw deny rules.

So if you grant write access to /tmp/mumble/barf you should expect it to 
always be accessible, regardless of whether someone creates an alias for it.

Please re-consider the rest of your analysis, because it doesn't work if 
there are only "allow" rules and no "deny" rules. You are correct that a 
pathname-based deny rule is trivially bypassable, that's why there 
aren't any :)

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
Botnets are the only commercially viable utility computing market


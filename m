Return-Path: <linux-kernel-owner+w=401wt.eu-S1760418AbYDNNth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760418AbYDNNth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:49:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760019AbYDNNtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:49:17 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47973 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759951AbYDNNtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:49:15 -0400
Date: Mon, 14 Apr 2008 07:48:58 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Crispin Cowan <crispin@crispincowan.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, paul.moore@hp.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, takedakn@nttdata.co.jp,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [TOMOYO #7 30/30] Hooks for SAKURA and TOMOYO.
Message-ID: <20080414134858.GV11962@parisc-linux.org>
References: <20080404122242.867070732@I-love.SAKURA.ne.jp> <20080404122408.986477936@I-love.SAKURA.ne.jp> <200804071140.59247.paul.moore@hp.com> <47FC8052.9070409@nttdata.co.jp> <20080409131151.GK11962@parisc-linux.org> <200804112312.HGE69734.LFOOHQOSFFMJtV@I-love.SAKURA.ne.jp> <20080411143013.GB11962@parisc-linux.org> <4802B63F.2010804@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4802B63F.2010804@crispincowan.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 06:41:19PM -0700, Crispin Cowan wrote:
> You are discussing a straw-man, because AppArmor (and I think TOMOYO) do 
> not operate that way.

Thanks for clarifying that.  I had to put a straw-man up for discussion
because nobody else had.  I'll continue this discussion in terms of
allow-rules.

> Rather, it is "can write to /tmp/ntpd/*". You *grant* permissions. You 
> do *not* throw deny rules.

So primarily we're concerned here with things that are running as root,
daemons and the like.  Normal unix file permissions (or ACLs, if you
must) are adequate to handle anything not running as uid 0.

I don't see what apparmour and tomoya buy us that namespaces can't.
Maybe a nicer interface, but that's something that a nice userspace
management interface can handle.

Create an empty namespace.  Create /tmp/ntpd in it.  Bind the outside
/tmp/ntpd onto that directory.  Presto, the equivalent to an allow-rule
of 'can write to /tmp/ntpd/*'.

The equivalent of 'can read, but not write /home/crispin/.ssh/id_rsa.pub'
will need r-o bind mounts, which Miklos seems to have become distracted
from by working on the hooks for TOMOYA.

Do you have a good example of something that apparmour can protect against
that namespaces can't?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

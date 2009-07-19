Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbZGSM1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbZGSM1H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 08:27:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZGSM1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 08:27:06 -0400
Received: from pond.fysh.org ([166.84.7.109]:40893 "EHLO pond.fysh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbZGSM1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 08:27:05 -0400
Date: Sun, 19 Jul 2009 13:27:01 +0100
From: Athanasius <link@miggy.org>
To: Julien TINNES <jt@cr0.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@ubuntu.com>,
       Eugene Teo <eugene@redhat.com>, Athanasius <link@miggy.org>
Subject: Re: [link@miggy.org: Re: [patch 2/8] personality: fix
	PER_CLEAR_ON_SETID (CVE-2009-1895)]
Message-ID: <20090719122701.GJ6722@miggy.org>
Mail-Followup-To: Julien TINNES <jt@cr0.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Greg KH <gregkh@suse.de>, Tavis Ormandy <taviso@sdf.lonestar.org>,
	Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@ubuntu.com>,
	Eugene Teo <eugene@redhat.com>, Athanasius <link@miggy.org>
References: <20090718202512.GA19587@suse.de> <alpine.LFD.2.01.0907181342500.13838@localhost.localdomain> <20090718212812.GI6722@miggy.org> <4A6278FD.20807@cr0.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6278FD.20807@cr0.org>
X-gpg-fingerprint: E218CE1D
X-gpg-key: http://www.fysh.org/~athan/gpg-key
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 06:38:05PM -0700, Julien TINNES wrote:
> A process should be able to change it's own personality, there is no
> issue with this as long as we restrict the set of personalities which
> are preserved when the process gets new privileges.

  And it's that "as long as we ..." that still bothers me.  I've *never*
had any need for any use of this personality feature and this net/tun.c
exploit has proven there can be security gotchas with it.  I'd prefer if
the whole thing were a kernel config option so I can easily turn it off
and have peace of mind that no future security bug discovered will
affect me.
  No, I'd rather not look into using something like SELinux to turn off
one syscall, as that's introducing a whole extra layer of complexity.
Indeed the same exploit can instead make use of SELinux being misconfigured
by some vendors.

  If the feature didn't already exist and was now proposed what are the
chances it would make it into the mainline kernel without having a
config option control it ?  I'm wondering what its chances would be of
being accepted at all given the tentacles it seems to throw in all
directions (search for any of the actual personality feature flags in
the kernel source).
  I'd also hazard that such ABI-compatibility with binaries from other
OSes is a feature the great majority of Linux users have never used and
now never will.

-- 
- Athanasius = Athanasius(at)miggy.org / http://www.miggy.org/
                  Finger athan(at)fysh.org for PGP key
	   "And it's me who is my enemy. Me who beats me up.
Me who makes the monsters. Me who strips my confidence." Paula Cole - ME

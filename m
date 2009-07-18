Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbZGRVu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbZGRVu2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 17:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbZGRVuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 17:50:25 -0400
Received: from pond.fysh.org ([166.84.7.109]:59234 "EHLO pond.fysh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbZGRVuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 17:50:25 -0400
X-Greylist: delayed 1329 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jul 2009 17:50:25 EDT
Date: Sat, 18 Jul 2009 22:28:12 +0100
From: Athanasius <link@miggy.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg KH <gregkh@suse.de>, Julien Tinnes <jt@cr0.org>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@ubuntu.com>,
       Eugene Teo <eugene@redhat.com>, Athanasius <link@miggy.org>
Subject: Re: [link@miggy.org: Re: [patch 2/8] personality: fix
	PER_CLEAR_ON_SETID (CVE-2009-1895)]
Message-ID: <20090718212812.GI6722@miggy.org>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Greg KH <gregkh@suse.de>, Julien Tinnes <jt@cr0.org>,
	Tavis Ormandy <taviso@sdf.lonestar.org>,
	Christoph Hellwig <hch@infradead.org>, Kees Cook <kees@ubuntu.com>,
	Eugene Teo <eugene@redhat.com>, Athanasius <link@miggy.org>
References: <20090718202512.GA19587@suse.de> <alpine.LFD.2.01.0907181342500.13838@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907181342500.13838@localhost.localdomain>
X-gpg-fingerprint: E218CE1D
X-gpg-key: http://www.fysh.org/~athan/gpg-key
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 01:48:06PM -0700, Linus Torvalds wrote:
> On Sat, 18 Jul 2009, Greg KH wrote:
> > 
> > and you have the whole idea of personalities being some kind of security
> > mechanism exposed as a joke.
> 
> It's _not_ a "security mechanism". It never was.
...
> In the absense of raised capabilities, the personality flags don't matter: 
> because they aren't security. If you have a personality flag that says "I 
> want to mmap at virtual address zero", you're still going to be limited by 
> the security layer, and if the security layer says "nope, you can't do 
> that", then your personality doesn't matter.
> 
> See?

  I can understand and appreciate that, yes.

  However the content of 'cat /proc/execdomains' is mis-leading for
the default Execution Domain.  The string '0-0' implies either that you
can only set 1 of 3 personalities whilst this Execution Domain is current
OR that this Execution Domain will only be used whilst the set personality
is one of those 3.  But neither is actually true as this default Execution
Domain (being the only one in vanilla kernel tree) is a special case.
  If you don't see a valid reason to change personality(2) behaviour (thus
still allowing setting aribtrary personality values) then surely it would
make more sense for the default domain to set pers_high to PER_MASK ?
I'd suggest it actually be 0xffffffff but the field is only a char.

-- 
- Athanasius = Athanasius(at)miggy.org / http://www.miggy.org/
                  Finger athan(at)fysh.org for PGP key
	   "And it's me who is my enemy. Me who beats me up.
Me who makes the monsters. Me who strips my confidence." Paula Cole - ME

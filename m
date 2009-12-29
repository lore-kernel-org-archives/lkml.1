Return-Path: <linux-kernel-owner+w=401wt.eu-S1751365AbZL2Tfn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbZL2Tfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 14:35:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbZL2Tfm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 14:35:42 -0500
Received: from toccata.ens-lyon.fr ([140.77.166.68]:48383 "EHLO
	toccata.ens-lyon.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbZL2Tfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 14:35:41 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Dec 2009 14:35:40 EST
Date: Tue, 29 Dec 2009 20:28:27 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what's the purpose of MAXHOSTNAMELEN?
Message-ID: <20091229192827.GF4815@const>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	"Robert P. J. Day" <rpjday@crashcourse.ca>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0912291416230.4967@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0912291416230.4967@localhost>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day, le Tue 29 Dec 2009 14:19:30 -0500, a écrit :
>   so lots of people define it but no one uses it.  it *is* exported to
> user space in /usr/include/asm/param.h, but i still have no idea what
> it's for in user space.  obsolete?

It's like all these *MAX* #defines: they are a bad way to express the
system limitations.  They are bad because they end up compiled-in, but
also because people understand them as "a typical allocation length" and
get lazy.  The typical example is PATH_MAX, which is #defined to 4096.
A _lot_ of applications thus keep allocating 4KB for all paths.

See
http://www.gnu.org/software/hurd/hurd/porting/guidelines.html#PATH_MAX_tt_MAX_PATH_tt_MAXPATHL

If you could drop it (would be completely POSIX-compliant), that'd be a
great service to GNU/Hurd porters, but I bet you'll also get a lot of
angry people.

Samuel

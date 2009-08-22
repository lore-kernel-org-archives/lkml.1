Return-Path: <linux-kernel-owner+w=401wt.eu-S933056AbZHVRWz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbZHVRWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 13:22:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932709AbZHVRWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 13:22:54 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55497 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932684AbZHVRWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 13:22:53 -0400
X-Sasl-enc: t3+TPQum02c97t1b66GezY0efJ/IdGmpR8E7DLafDDRp 1250961774
Date: Sat, 22 Aug 2009 14:22:52 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: Theodore Tso <tytso@mit.edu>, David Wagner <daw-news@cs.berkeley.edu>,
       linux-kernel@vger.kernel.org
Subject: Re: Security: information leaks in /proc enable keystroke recovery
Message-ID: <20090822172252.GA4894@khazad-dum.debian.net>
References: <200908152221.n7FMLRuw005799@taverner.cs.berkeley.edu> <20090816003326.GC7554@mit.edu> <h67kou$ahr$1@taverner.cs.berkeley.edu> <20090816013346.GA17958@mit.edu> <h6a8da$40j$1@taverner.cs.berkeley.edu> <20090817022215.GI17958@mit.edu> <20090821140241.GB1337@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090821140241.GB1337@ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Aug 2009, Pavel Machek wrote:
> /proc/interrupts ? various interfaces powertop uses?
> 
> I did not have chance to read the paper yet, but... does not ssh have
> bad problem in that case?

I am told that SSH tries it best to take constant time for everything
that is even remotely sensitive (or at least, it should)... but it, as
well as openssl, gpg, gnutls and libc for that matter, can't really
protect themselves from sidechannels and information leaks that show up
when one abuses other CPUs (especially if SMT is operational) to gather
behaviour data of the other tasks/processes/threads in the system, or
when one gets to watch the cache misses, CPU pipeline stalls, etc.

I would also expect that *any* timing-related, power-related or
cache-/brach-prediction-/pipeline-stall-/CPU-behaviour- related high-
and medium-precision statistic to be viable side-channels to leak data.

These things are way too subtle to play the "prove it to me then" crap:
it often takes a stroke of geniality on top of extreme skill to find,
let alone exploit them.  Therefore, it is really difficult to say "they
don't exist".

IMO, it is too hard a problem to try to close for real, but we really
should try to have all our crypto be constant-everything as much as we
can (constant CPU effort, constant timing, constant memory pattern
access), and to clamp the precision of measurements sent to userspace to
the strictly needed for them to be useful for system administration,
unless the kernel was compiled to expose high-precision statistics for
development work.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

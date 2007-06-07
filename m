Return-Path: <linux-kernel-owner+w=401wt.eu-S936748AbXFGUiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936748AbXFGUiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 16:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934808AbXFGUiH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 16:38:07 -0400
Received: from smtp113.sbc.mail.re2.yahoo.com ([68.142.229.92]:49073 "HELO
	smtp113.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S934450AbXFGUiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 16:38:06 -0400
X-YMail-OSG: DX_bQXMVM1mayb29uJ3Wg62p7HlH3bz9cQI5zLDvmQz1OSvOgiJEpeWHDUMISQy0bEys4rJ5NV_B1LYFonOfnVt3GtPz83EKBm.CwawbFjkWYR2nDS60JQ--
Date: Thu, 7 Jun 2007 15:37:57 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Albert Cahalan <acahalan@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       ebiederm@xmission.com, torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH] /proc/pid/maps doesn't match "ipcs -m" shmid
Message-ID: <20070607203757.GA531@vino.hallyn.com>
References: <787b0d920706062027s5a8fd35q752f8da5d446afc@mail.gmail.com> <20070606204432.b670a7b1.akpm@linux-foundation.org> <787b0d920706062153u7ad64179p1c4f3f663c3882f@mail.gmail.com> <1181233393.9995.14.camel@dyn9047017100.beaverton.ibm.com> <787b0d920706070943h6ac65b85nee5b01600905be08@mail.gmail.com> <1181235997.9995.23.camel@dyn9047017100.beaverton.ibm.com> <20070607124824.27e909fd.akpm@linux-foundation.org> <1181246363.9995.37.camel@dyn9047017100.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181246363.9995.37.camel@dyn9047017100.beaverton.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Badari Pulavarty (pbadari@us.ibm.com):
> On Thu, 2007-06-07 at 12:48 -0700, Andrew Morton wrote:
> > On Thu, 07 Jun 2007 10:06:37 -0700
> > Badari Pulavarty <pbadari@us.ibm.com> wrote:
> > 
> > > On Thu, 2007-06-07 at 12:43 -0400, Albert Cahalan wrote:
> > > > On 6/7/07, Badari Pulavarty <pbadari@us.ibm.com> wrote:
> > > > 
> > > > > BTW, I agree with Eric that its would be nice to use shmid as part
> > > > > of name instead of forcing to be as inode number. It should be
> > > > > possible for pmap to workout shmid from "key" or name. Isn't it ?
> > > > 
> > > > It is not at all nice.
> > > > 
> > > > 1. it's incompatible ABI breakage
> > > > 2. where will you put the key then, in the inode? :-)
> > > 
> > > Nope. Currently "key" is part of the name (but its not unique).
> > > 
> > > > 
> > > > Changing to "SYSVID%d" is no good either. Look, people
> > > > are ***parsing*** this stuff in /proc. The /proc filesystem
> > > > is not some random sandbox to be playing in.
> > > > 
> > > > Before you go messing with it, note that the device number
> > > > also matters. (it's per-boot dynamic, but that's OK)
> > > > That's how one knows that /SYSV00000000 is not just
> > > > a regular file; sadly these didn't get a non-/ prefix.
> > > > (and no you can't fix that now; it's way too late)
> > > > 
> > > > Next time you feel like breaking an ABI, mind putting
> > > > "LET'S BREAK AN ABI!" in the subject of your email?
> > > 
> > > I am not breaking ABI. Its already broken in the current
> > > mainline. I am trying to fix it by putting back the ino#
> > > as shmid. Eric had a suggestion that, instead of depending
> > > on the inode# to be shmid, we could embed shmid into name
> > > (instead of "key" which is currently not unique).
> > > 
> > > > BTW, I suspect this kind of thing also breaks:
> > > > a. fuser, lsof, and other resource usage display tools
> > > > b. various obscure emulators (similar to valgrind)
> > > 
> > > If you strongly feel that "old" behaviour needs to be retained, 
> > 
> > yup, we should put it back.  The change was, afaik, accidental.
> > 
> > > here is the patch I originally suggested.
> > 
> > Confused.  Will this one-liner fix all the userspace breakage to which
> > Albert refers?
> 
> Yes. Albert, please correct me if I am wrong.

It will, but could lead to two different inodes with the same i_ino,
right?

thanks,
-serge

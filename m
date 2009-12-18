Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZLRPNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZLRPNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 10:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754491AbZLRPN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 10:13:29 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:63647 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477AbZLRPN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 10:13:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=Tyu611+WiW32bFNHX6SOOrVasDFMROAYjU2WAyXHhzEt0MlWqb/yDcUCJMoGUspAVX
         2JZK0fd4bwI0PXEZxqqAToqa8NVwNxoSFjtmqX1wK6/VV79AoZL1a1dA+F8aILcdmHaY
         DaK7D9QQZdodgr3dzqTWCqCeFqQKUt3vVaIdw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
Date: Fri, 18 Dec 2009 16:11:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Valdis.Kletnieks@vt.edu, Mikulas Patocka <mpatocka@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com> <24653.1261110557@localhost> <m3my1g1hmr.fsf@intrepid.localdomain>
In-Reply-To: <m3my1g1hmr.fsf@intrepid.localdomain>
MIME-Version: 1.0
Message-Id: <200912181611.50871.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 December 2009 03:28:12 pm Krzysztof Halasa wrote:
> Valdis.Kletnieks@vt.edu writes:
> 
> > Yeah, but I respectfully submit that if the regexp '^\t{6}' matches a non-
> > continuation line, it's probably in its rights to whinge.
> 
> Yes, but don't make it a hard error, only a suggestion that something is
> probably really wrong.
> 
> > fs/reisersfs/do_balan.c, lines 460-477 (note: 3 leading tabs elided)
> >
> > 				leaf_paste_entries(&bi,
> > 						   n +
> > 						   item_pos
> > 						   -
> > 						   ret_val,
> > 						   l_pos_in_item,
> > 						   1,
> > 						   (struct
> > 						    reiserfs_de_head
> > 						    *)
> > 						   body,
> > 						   body
> > 						   +
> > 						   DEH_SIZE,
> > 						   tb->
> > 						   insert_size
> > 						   [0]
> > 				    );
> >
> > Yes, that used to be 24 more columns to the right.  Gaak.
> 
> Precisely. It's a clear show of the damage hard rules like that do.

It is not a hard rule and the above damage was done in 2005 when some
random developer (Linus Torvalds?  Is this even a real name? ;-) decided
to mindlessly pass do_balan.c file through Lindent script and later
didn't finish the task of cleaning the code properly (see commit bd4c625
for details).

We didn't even have checkpatch.pl back then (it was added in 2007).

> I can't even tell how the code should be fixed and if the simple merging
> would do, since I can't really imagine how it would look like :-)

The old code [ no tabs removed ]:

-                           leaf_paste_entries (bi.bi_bh, n + item_pos - ret_val, l_pos_in_item, 1,
-                                               (struct reiserfs_de_head *)body,
-                                               body + DEH_SIZE, tb->insert_size[0]
-                               );

--
Bartlomiej Zolnierkiewicz

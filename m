Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbZLROwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbZLROwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 09:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753627AbZLROww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 09:52:52 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51856 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbZLROwv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 09:52:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IwBwrxKK4RDcoEoVwwmlGN86shhDbNLD4J5ve2oW5p2BymVZs6PbRAHlrdPtvpbIvB
         2bZxHrNqfNKPeUEvuvL350IJduL8mDpWKDNNJ9cfD9OxE/X/UBAhFFyrFWUYcyugBkiP
         3b5d5iZwG3+YxWd32/Cj1Xi4xsgyY+GMdN6hQ=
MIME-Version: 1.0
In-Reply-To: <m3my1g1hmr.fsf@intrepid.localdomain>
References: <Pine.LNX.4.64.0912151656010.29183@hs20-bc2-1.build.redhat.com>
	 <20091217061229.GD3946@linux-sh.org>
	 <m3tyvqgfs4.fsf@intrepid.localdomain>
	 <Pine.LNX.4.64.0912171744070.21142@hs20-bc2-1.build.redhat.com>
	 <24653.1261110557@localhost> <m3my1g1hmr.fsf@intrepid.localdomain>
Date: Fri, 18 Dec 2009 08:52:48 -0600
Message-ID: <7004b08e0912180652p42777da3h70906f2fbdb60a69@mail.gmail.com>
Subject: Re: [PATCH] Drop 80-character limit in checkpatch.pl
From: kevin granade <kevin.granade@gmail.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Valdis.Kletnieks@vt.edu, Mikulas Patocka <mpatocka@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 8:28 AM, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> Valdis.Kletnieks@vt.edu writes:
>
>> Yeah, but I respectfully submit that if the regexp '^\t{6}' matches a non-
>> continuation line, it's probably in its rights to whinge.
>
> Yes, but don't make it a hard error, only a suggestion that something is
> probably really wrong.
>
>> fs/reisersfs/do_balan.c, lines 460-477 (note: 3 leading tabs elided)
>>
>>                               leaf_paste_entries(&bi,
>>                                                  n +
>>                                                  item_pos
>>                                                  -
>>                                                  ret_val,
>>                                                  l_pos_in_item,
>>                                                  1,
>>                                                  (struct
>>                                                   reiserfs_de_head
>>                                                   *)
>>                                                  body,
>>                                                  body
>>                                                  +
>>                                                  DEH_SIZE,
>>                                                  tb->
>>                                                  insert_size
>>                                                  [0]
>>                                   );
>>
>> Yes, that used to be 24 more columns to the right.  Gaak.
>
> Precisely. It's a clear show of the damage hard rules like that do.
> I can't even tell how the code should be fixed and if the simple merging
> would do, since I can't really imagine how it would look like :-)

I think you're missing the point, there is no simple fix for this sort
of formatting problem.  The 80 column hard limit didn't cause this
mangling, someone applying an obviously misguided quick fix to the
too-long line caused the problem.  The appropriate thing to do when
checkpatch tells you that a line is too long isn't necessarily to chop
the line into pieces.  The appropriate thing to do is look at the
surrounding context and determine what the underlying problem is.  In
this case Bart pointed out that quite a lot of the overly-complex
parameter could be reasonably moved to a helper macro, and the
too-long surrounding function should be broken up into manageable
pieces.

The fundamental disconnect here is that some people seem to think that
style guidelines like "no lines over 80 columns" are goals, they
aren't, they are just heuristics that have been found to point out bad
coding practices.

Note: I'm not specifically arguing for keeping the 80-column rule, the
project I work on uses 100 columns, and that's quite workable, but I
haven't had any problem working with 80 columns as a limit either.  I
do however think that just removing the limit without replacing it
with something better is a bad idea.

-Kevin Granade

> --
> Krzysztof Halasa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

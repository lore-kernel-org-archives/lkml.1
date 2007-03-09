Return-Path: <linux-kernel-owner+w=401wt.eu-S2992823AbXCIA6I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992823AbXCIA6I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:58:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992824AbXCIA6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:58:08 -0500
Received: from web52507.mail.yahoo.com ([206.190.48.190]:45941 "HELO
	web52507.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2992823AbXCIA6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:58:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=szdt3N9FzXUAjY0775upFi+3iVtKdloAVJxQqPX5GwlDIKOwDrOwo+z5WObg/Cc4udTut2szrwmCXH0G9J9YqEWYhgmhq9OsOqv50zh2qaKGz0jBDM0t2+akAa9x4qLnk7/KSUlqINsGCPRSK+ERCNc6LLZ90Y6q62iubarLewE=;
X-YMail-OSG: 0oa8ixEVM1m6JMJgDHMduDzYqutSBcXwewdd7vX8Y0QXupVS2vu3Ksc0ks1OylJxlE_HRFEySkR5KVCYk_T5hh0lKohMpXgQuztowLME6zF.uyaub9r9RrP.M893DjBSFgsg_ZyLFArHvO0h0oTVGR9kqXRc_D5sVhsUHUl_gAVUrp4mQjR3
Date: Thu, 8 Mar 2007 16:58:03 -0800 (PST)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: Raid 10 Problems?
To: Michael Tokarev <mjt@tls.msk.ru>, Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: dean gaudet <dean@arctic.org>, Marc Perkel <mperkel@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org
In-Reply-To: <45F09698.7090606@tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <464915.77231.qm@web52507.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Michael Tokarev <mjt@tls.msk.ru> wrote:

> Jan Engelhardt wrote:
> []
> > The other thing is, the bitmap is supposed to be
> written out at intervals,
> > not at every write, so the extra head movement for
> bitmap updates should
> > be really low, and not making the tar -xjf process
> slower by half a minute.
> > Is there a way to tweak the write-bitmap-to-disk
> interval? Perhaps 
> > something in /sys or ye olde /proc. Maybe
> linux-raid@ knows 8)
> 
> Hmm.  Bitmap is supposed to be written before actual
> data write, to mark
> the to-be-written areas of the array as "being
> written", so that those
> areas can be detected and recovered in case of power
> failure during
> actual write.
> 
> So in case of writing to a clean array, head
> movement always takes place -
> first got to bitmap area, and second to the actual
> data area.
> 
> That "written at intervals" is about clearing the
> bitmaps after some idle
> time.
> 
> In other words, dirtying bitmap bits occurs right
> before actual write,
> and clearing bits occurs at intervals.
> 
> Sure, if you write to (or near) the same place again
> and again, without
> giving a chance to md subsystem to actually clean
> the bitmap, there will
> be no additional head movement.  And that means, for
> example, tar -xjf
> sometimes, since filesystem will place the files
> being extracted close to
> each other, thus hitting the same bit in the bitmap,
> hence md will skip
> repeated bitmap updates in this case.
> 
> /mjt
> 

I assume that if a block is already dirty then that is
cached somewhere in memory so you aren't writing to
the bitmap unless you're changing it for clean to
dirty? If that's the case then I would think that
writing to the map wouldn't be that expensive?



 
____________________________________________________________________________________
Now that's room service!  Choose from over 150,000 hotels
in 45,000 destinations on Yahoo! Travel to find your fit.
http://farechase.yahoo.com/promo-generic-14795097

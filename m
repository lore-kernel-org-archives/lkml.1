Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbXHZEV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbXHZEV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 00:21:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750913AbXHZEVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 00:21:50 -0400
Received: from web33010.mail.mud.yahoo.com ([209.191.69.125]:21522 "HELO
	web33010.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750857AbXHZEVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 00:21:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=jPxcN6Jb8wTs2/drXxS1E82d+ylCoV0B7Wjm13jPh5jYlsef0Onn/1+J3YPaTr4QF7O8Bhrr5rZt35ibTpLVA5pkEYhoNJ4EKsqYI7WU3p4Mqnlgx3cgVtG8Lrv+CmjnUjH2tHqFHvUJIdD8gUxGG12fgc1Kyh4JFUaM2brUEPY=;
X-YMail-OSG: 47zEdIwVM1mmqqxOYVZbwxdURok1aOTKjsZdky5JDDsfZYBTyxdlhQBh3_KArifO_27X.UA76X5Q.n2XQukrLn9rkW8K9ouXdvLXjCdNQoxlvG.EhIq5qchwrFEdOQ--
Date: Sat, 25 Aug 2007 21:15:07 -0700 (PDT)
From: Stephen Cameron <smcameron@yahoo.com>
Subject: Re: cciss: fix error reporting for SG_IO
To: akpm@osdl.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <213452.45405.qm@web33010.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > This fixes a problem with the way cciss was filling out the "errors"
> > field of the request structure upon completion of requests.
> > Previously, it just put a 1 or a 0 in there and used the negation
> > of this as the uptodate parameter to one of the functions in the
> > block layer, being a block device.  For the SG_IO ioctl, this was not
> > sufficient, and we noticed that, for example, sg_turs from sg3_utils
> > did not correctly detect problems due to cciss having set rq->errors
> > incorrectly.
> 
> Do we think this problem is sufficiently serious to merit merging
> this (largeish) patch into 2.6.23?
> 
> I'm thinking "no", but that might be wrong...

Without saying too much (I hope), if you want multipath i/o to cciss 
devices to work which depend on device mapper, (which I can't say what 
specific device(s) match that description without getting myself into 
trouble) then you want this patch.  If my understanding is correct, then
some DM multipath stuff depends on TUR response to know if a path is
failed.  If you don't care about that, then you can skip it.
 
-- steve



       
____________________________________________________________________________________
Moody friends. Drama queens. Your life? Nope! - their life, your story. Play Sims Stories at Yahoo! Games.
http://sims.yahoo.com/  

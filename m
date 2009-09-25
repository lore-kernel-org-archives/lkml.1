Return-Path: <linux-kernel-owner+w=401wt.eu-S1751865AbZIYRf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbZIYRf1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 13:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZIYRfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 13:35:25 -0400
Received: from mx.treblig.org ([80.68.94.177]:44102 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbZIYRfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 13:35:24 -0400
Date: Fri, 25 Sep 2009 19:35:23 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Valdis.Kletnieks@vt.edu
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andreas Gruenbacher <agruen@suse.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: new O_NODE open flag
Message-ID: <20090925183523.GA6065@gallifrey>
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu> <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu> <20090925123747.GA31228@gallifrey> <9988.1253899252@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9988.1253899252@turing-police.cc.vt.edu>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.29.2-bytemark-kvm-tickless-2009-05-05 (i686)
X-Uptime: 19:31:13 up 122 days, 11:52,  1 user,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu) wrote:
> On Fri, 25 Sep 2009 13:37:47 BST, "Dr. David Alan Gilbert" said:
> 
> > Given an fd opened in this way is it possible to reopen it normally and
> > be guarenteed to get the same object?
> 
> It's not possible even without this flag. Consider:
> 
>         fd1 = open("/tmp/foo",flags);
>         rc = rename("/tmp/foo","/tmp/bar");
>         fd2 = open("/tmp/foo",flags);
> 
> Or were you asking if *absent that sort of tomfoolery* if it would work?

I know it's not possible without this flag, my interest is whether
it would be possible WITH this flag to promote an fd opened with the
O_NODE to a normal fd, guaranteeing that it's still operating on the
same object.  The case I'm (vaguely) thinking of is open with O_NODE,
fstat it, come to the conslusion it's not a device and then proceed
to open it and read from it.

Dave


-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

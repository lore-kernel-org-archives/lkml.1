Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbXHRDnF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbXHRDnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 23:43:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbXHRDmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 23:42:54 -0400
Received: from hu-out-0506.google.com ([72.14.214.235]:60758 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbXHRDmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 23:42:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Z/OK6XaEwem5+ypAzR3rpESuphDwzjzzPI7NHHw7BrGoVgNnN141YoGV900W2ufIUH50yt/BcSflSGTfzG2VeE7HcJPPsTy9W3XyeDDr0YdGjZ4GVF7069ZK5BbAm3JqdRf/YjvDOs/urtQpJEDNf6JAGVJkh4Q+sm++zg15Atw=
Date: Sat, 18 Aug 2007 07:42:46 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, sfrench@us.ibm.com
Subject: Re: + cifs-check-for-granted-memory.patch added to -mm tree
Message-ID: <20070818034246.GA7225@cvg>
References: <200708172150.l7HLoXqT031088@imap1.linux-foundation.org> <9a8748490708171517m4c6f1330jf7990b68cebe4768@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490708171517m4c6f1330jf7990b68cebe4768@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jesper Juhl - Sat, Aug 18, 2007 at 12:17:33AM +0200]
| On 17/08/07, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
| >
| > The patch titled
| >      CIFS: check for granted memory
| > has been added to the -mm tree.  Its filename is
| >      cifs-check-for-granted-memory.patch
| >
| > *** Remember to use Documentation/SubmitChecklist when testing your code ***
| >
| > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
| > out what to do about this
| >
| > ------------------------------------------------------
| > Subject: CIFS: check for granted memory
| > From: Cyrill Gorcunov <gorcunov@gmail.com>
| >
| > Add a check for granted memory to prevent possible NULL pointer usage.
| >
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > Cc: Steven French <sfrench@us.ibm.com>
| > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
| > ---
| >
| >  fs/cifs/sess.c |    4 ++++
| >  1 files changed, 4 insertions(+)
| >
| > diff -puN fs/cifs/sess.c~cifs-check-for-granted-memory fs/cifs/sess.c
| > --- a/fs/cifs/sess.c~cifs-check-for-granted-memory
| > +++ a/fs/cifs/sess.c
| > @@ -372,6 +372,10 @@ CIFS_SessSetup(unsigned int xid, struct
| >
| >         /* 2000 big enough to fit max user, domain, NOS name etc. */
| >         str_area = kmalloc(2000, GFP_KERNEL);
| > +       if (str_area == NULL) {
| > +               cifs_small_buf_release(smb_buf);
| > +               return -ENOMEM;
| > +       }
| 
| The patch, as such, is fine - not arguing against it, but as a matter
| of style; don't we usually prefer the "if (!foo)" form over "if (foo
| == NULL)" ??

I just don't wanna mess 'if (!ptr)' and 'if (ptr == NULL)'
in the procedure. Look at the code ;) Some procs in CIFS
_does_ use '!ptr' but others - 'ptr == NULL'. So in the
proc being patched 'if (ptr == NULL)' is assumed.

| 
| -- 
| Jesper Juhl <jesper.juhl@gmail.com>
| Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
| Plain text mails only, please      http://www.expita.com/nomime.html
| 


		Cyrill


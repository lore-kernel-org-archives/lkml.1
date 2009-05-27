Return-Path: <linux-kernel-owner+w=401wt.eu-S1761022AbZE0HEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761022AbZE0HEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758187AbZE0HEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:04:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:37478 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757659AbZE0HEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:04:32 -0400
Subject: Re: [PATCH -tip] Documentation/accounting/getdelays.c intialize
 the variable before using it
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@in.ibm.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <20090526235442.d793ac89.akpm@linux-foundation.org>
References: <1242796484.3260.12.camel@localhost.localdomain>
	 <20090526235442.d793ac89.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 12:33:26 +0530
Message-Id: <1243407806.12592.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 23:54 -0700, Andrew Morton wrote:
> On Wed, 20 May 2009 10:44:44 +0530 Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > 
> > May be in some cases cmd_type will be used uninitialized.
> > 
> > Also fixes compilation warning:
> > 
> >    CC [M]  Documentation/DocBook/procfs_example.o
> >   Documentation/accounting/getdelays.c: In function ___main___:
> >   Documentation/accounting/getdelays.c:249: warning: ___cmd_type___ may be used uninitialized in this function
> > 
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  Documentation/accounting/getdelays.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
> > index 7ea2311..36aae3b 100644
> > --- a/Documentation/accounting/getdelays.c
> > +++ b/Documentation/accounting/getdelays.c
> > @@ -246,7 +246,7 @@ void print_ioacct(struct taskstats *t)
> >  
> >  int main(int argc, char *argv[])
> >  {
> > -	int c, rc, rep_len, aggr_len, len2, cmd_type;
> > +	int c, rc, rep_len, aggr_len, len2, cmd_type = TASKSTATS_CMD_ATTR_UNSPEC;
> >  	__u16 id;
> >  	__u32 mypid;
> >  
> 
> >From my reading of the code there is no bug here - we'll only use
> cmd_type if tid != 0, and cmd_type is always initialised when tid != 0.
> 
> But I suppose we should squish the warning anyway.
> 
> btw, whichever version of gcc you're using has apparently regressed -
> my gcc-4.3.0 manages to work out what's happening.  Hence please prefer
> to include the gcc version in the changelog.  And send a bug report at
> the gcc guys if appropriate ;)

my gcc version is 4.3.2 20081105 (Red Hat 4.3.2-7) (GCC)

But I heard from jejb that 4.3.3 fixed some of these warnings.

Thanks,
--
JSR


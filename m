Return-Path: <linux-kernel-owner+w=401wt.eu-S933150AbZFOSsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150AbZFOSsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:48:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765369AbZFOSsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:48:41 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:50834 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764815AbZFOSsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:48:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Ocs0P99hOJ/Nlw/VsiP0393HVJ0+OBkqpYqGRVs2UfV6lPBWTRz+9rADqxjSVGyoDp
         vlysmuKEiEIIuk7DWqssU2zXoH9tLCY0dpOpxgy1vNUrxJxxV7kxezcqq3BuU9n7v/dz
         Rg9Jh8W7rH5JvLYm9+SMdeyN3CeH+ureuBFlQ=
Subject: Re: [PATCH v3] filter local function prefixed by $L
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org, Wang Liming <liming.wang@windriver.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.DEB.2.00.0906151214160.30161@gandalf.stny.rr.com>
References: <cover.1244994151.git.wuzj@lemote.com>
	 <d0983eb71d7517d0e536352f3288e995abbb0e07.1244994151.git.wuzj@lemote.com>
	 <4A366FF7.2010206@caviumnetworks.com>
	 <alpine.DEB.2.00.0906151214160.30161@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Tue, 16 Jun 2009 02:48:30 +0800
Message-Id: <1245091710.6381.74.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-15 at 12:30 -0400, Steven Rostedt wrote:
> On Mon, 15 Jun 2009, David Daney wrote:
> 
> > Wu Zhangjin wrote:
> > > From: Wu Zhangjin <wuzj@lemote.com>
> > > 
> > > this patch fixed the warning as following:
> > > 
> > > mipsel-linux-gnu-objcopy: 'fs/proc/.tmp_gl_devices.o': No such file
> > > mipsel-linux-gnu-ld: fs/proc/.tmp_gl_devices.o: No such file: No such
> > > file or directory
> > > rm: cannot remove `fs/proc/.tmp_gl_devices.o': No such file or directory
> > > rm: cannot remove `fs/proc/.tmp_mx_devices.o': No such file or directory
> > > 
> > > the real reason of above warning is that the $Lxx local functions will
> > > be treated as global symbols, so, should be filtered.
> > > 
> > > Signed-off-by: Wu Zhangjin <wuzj@lemote.com>
> > > ---
> > >  scripts/recordmcount.pl |    4 ++++
> > >  1 files changed, 4 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> > > index 533d3bf..542cb04 100755
> > > --- a/scripts/recordmcount.pl
> > > +++ b/scripts/recordmcount.pl
> > > @@ -343,6 +343,10 @@ sub update_funcs
> > >  	if (!$use_locals) {
> > >  	    return;
> > >  	}
> > > +	# filter $LXXX tags
> > > +	if ("$ref_func" =~ m/\$L/) {
> > > +		return;
> > > +	}
> > 
> > Certainly this is true for mips.  I doubt it is for all architectures targed
> > by Linux.
> 

have tried to use function_regex instead, but for I'm poor in playing
with regular expression of perl. at last, i use something easier like
above. and I _guess_ this problem maybe exist in some other platforms,
so just put it there.

> Yes, that should probably go into a mips only change. Unless you can 
> reproduce it on all other archs, or at least x86.
> 
> You could also do this in the function_regex variable.
> 
>  "^([0-9a-fA-F]+)\\s+<(.|[^\$]L.*?|\$[^L].*?|[^\$][^L].*?)>:"
> 

works well, and this seems mips64-specific, so, I moved this specific
function_regex to "if ($bits == 64) { ... }".

> There may even be a better way, but I'm not in the mood to look it up ;-)

seems not that easy to understand :-)

-- Wu Zhangjin


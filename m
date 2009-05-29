Return-Path: <linux-kernel-owner+w=401wt.eu-S1762311AbZE2QG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762311AbZE2QG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 12:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760341AbZE2QGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 12:06:19 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:48241 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760223AbZE2QGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 12:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=OwbyrvpEb0L9JpQpW5ttPB+szLt1eINn9NCCcu5lweDhYmQtNXIg2qzkAusGMh99T3
         r6J+AG4AwTJFotqLNbxGGxbwOyEG9v65MWmP9KcBH1ApQ5RBZWFndK9JjI4E1ToRgtQu
         12ADafKeZF3HqWoHiF4QR0ym+nEKAkDV3Alcw=
Subject: Re: [PATCH v2 2/6] mips dynamic function tracer support
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <alpine.DEB.2.00.0905291122260.31247@gandalf.stny.rr.com>
References: <cover.1243604390.git.wuzj@lemote.com>
	 <a00a91f6fc79b7d20b5b2193086e879dcafded46.1243604390.git.wuzj@lemote.com>
	 <alpine.DEB.2.00.0905291122260.31247@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Sat, 30 May 2009 00:06:06 +0800
Message-Id: <1243613166.18071.1.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-29 at 11:24 -0400, Steven Rostedt wrote:
> On Fri, 29 May 2009, wuzhangjin@gmail.com wrote:
> > diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> > index 409596e..a5d2ace 100755
> > --- a/scripts/recordmcount.pl
> > +++ b/scripts/recordmcount.pl
> > @@ -213,6 +213,17 @@ if ($arch eq "x86_64") {
> >      if ($is_module eq "0") {
> >          $cc .= " -mconstant-gp";
> >      }
> > +
> > +} elsif ($arch eq "mips") {
> > +	$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
> > +	$ld .= " -melf".$bits."btsmip";
> > +
> > +	$cc .= " -mno-abicalls -fno-pic ";
> > +
> > +    if ($bits == 64) {
> > +		$type = ".dword";
> > +    }
> > +
> >  } else {
> >      die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
> >  }
> > @@ -441,12 +452,12 @@ if ($#converts >= 0) {
> >      #
> >      # Step 5: set up each local function as a global
> >      #
> > -    `$objcopy $globallist $inputfile $globalobj`;
> > +    `$objcopy $globallist $inputfile $globalobj 2>&1 >/dev/null`;
> >  
> >      #
> >      # Step 6: Link the global version to our list.
> >      #
> > -    `$ld -r $globalobj $mcount_o -o $globalmix`;
> > +    `$ld -r $globalobj $mcount_o -o $globalmix 2>&1 >/dev/null`;
> 
> We still need to find out why these are giving errors. I don't like the 
> idea of hiding errors that might be useful. The better way is to change 
> the code to avoid having any warnings or errors.

get it :-)
I'm tuning it currently. 

thanks!
Wu Zhangjin
> 
> -- Steve
> 
> 
> >  
> >      #
> >      # Step 7: Convert the local functions back into local symbols
> > @@ -454,7 +465,7 @@ if ($#converts >= 0) {
> >      `$objcopy $locallist $globalmix $inputfile`;
> >  
> >      # Remove the temp files
> > -    `$rm $globalobj $globalmix`;
> > +    `$rm $globalobj $globalmix 2>&1 >/dev/null`;
> >  
> >  } else {
> >  
> > -- 
> > 1.6.0.4
> > 
> > 


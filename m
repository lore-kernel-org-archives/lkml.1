Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZLFMNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZLFMNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 07:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbZLFMNV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 07:13:21 -0500
Received: from bamako.nerim.net ([62.4.17.28]:52141 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbZLFMNU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 07:13:20 -0500
Date: Sun, 6 Dec 2009 13:13:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>,
       William Allen Simpson <william.allen.simpson@gmail.com>
Subject: Re: [PATCH] scripts/checkpatch.pl: Add warning about leading
 contination tests
Message-ID: <20091206131324.55436006@hyperion.delvare>
In-Reply-To: <4B1B6CB8.7000107@gmail.com>
References: <1260035884.11126.58.camel@Joe-Laptop.home>
	<4B1B6CB8.7000107@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Dec 2009 09:35:04 +0100, Eric Dumazet wrote:
> Joe Perches a écrit :
> > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > index bc4114f..c35933a 100755
> > --- a/scripts/checkpatch.pl
> > +++ b/scripts/checkpatch.pl
> > @@ -2064,6 +2064,11 @@ sub process {
> >  			CHK("multiple assignments should be avoided\n" . $herecurr);
> >  		}
> >  
> > +# Check use of leading logical continuation tests
> > +		if ($line =~ /^.\s*(\|\||&&)/) {
> > +			WARN("Continuation logic should be at end of previous line\n" . $herecurr);
> > +		}
> > +
> >  ## # check for multiple declarations, allowing for a function declaration
> >  ## # continuation.
> >  ## 		if ($line =~ /^.\s*$Type\s+$Ident(?:\s*=[^,{]*)?\s*,\s*$Ident.*/ &&
> > 
> > 
> 
> Fine with me, but please add relevant info in Documentation/CodingStyle ?

Not fine with me. Placing the binary logic operator at the beginning
of a line can be a deliberate choice, either to make complex binary
expressions more readable, or to avoid long lines. I don't see much
point in banning this style, which BTW is used over 8000 times in the
current kernel tree.

-- 
Jean Delvare

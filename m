Return-Path: <linux-kernel-owner+w=401wt.eu-S1751822AbZJPX0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbZJPX0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 19:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbZJPX0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 19:26:11 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57110 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZJPX0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 19:26:11 -0400
Date: Sat, 17 Oct 2009 00:26:12 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/7] checkpatch: fix false EXPORT_SYMBOL warning
Message-ID: <20091016232612.GA23876@penfold>
References: <1255718372-22805-1-git-send-email-apw@canonical.com>
 <1255718372-22805-7-git-send-email-apw@canonical.com>
 <1255719501.22917.54.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255719501.22917.54.camel@desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 11:58:21AM -0700, Daniel Walker wrote:
> On Fri, 2009-10-16 at 19:39 +0100, Andy Whitcroft wrote:
> 
> > -				WARN("EXPORT_SYMBOL(foo); should immediately follow its function/variable\n" . $herecurr);
> > +#print "FOO A<$lines[$realline_next - 1]> stat<$stat> name<$name>\n";
> > +				$suppress_export{$realline_next} = 2;
> > +			} else {
> > +				$suppress_export{$realline_next} = 1;
> >  			}
> >  		}
> > +		if (!defined $suppress_export{$linenr} &&
> > +		    $prevline =~ /^.\s*$/ &&
> > +                    ($line =~ /EXPORT_SYMBOL.*\((.*)\)/ ||
> > +		     $line =~ /EXPORT_UNUSED_SYMBOL.*\((.*)\)/)) {
> 
> ERROR: code indent should use tabs where possible
> #148: FILE: scripts/checkpatch.pl:1734:
> +                    ($line =~ /EXPORT_SYMBOL.*\((.*)\)/ ||$
> 
> This one line is spaced over instead of tabbed.. I guess checkpatch can
> even check itself, which is nice .. I'm not sure this matters since this
> it's perl tho..
> 
> Do you apply any kind of coding style to checkpatch itself ?

Yeah normally I checkpatch it, and ignore the width issues as the long
regexps are not always sensibly wrappable.  I rushed this lot out as I
am travelling tommorrow.  Sigh.  Never rush out a set of patches.

-apw

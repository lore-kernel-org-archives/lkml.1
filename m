Return-Path: <linux-kernel-owner+w=401wt.eu-S1760891AbYFGGC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760891AbYFGGC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 02:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbYFGGCt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 02:02:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756105AbYFGGCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 02:02:48 -0400
Date: Fri, 6 Jun 2008 23:02:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Andy Whitcroft <apw@shadowen.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: update checkpatch.pl to version 0.19
Message-Id: <20080606230239.c1a8c002.akpm@linux-foundation.org>
In-Reply-To: <20080606233037.GA8548@kroah.com>
References: <200806061922.m56JMJuq025990@hera.kernel.org>
	<20080606233037.GA8548@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 16:30:37 -0700 Greg KH <greg@kroah.com> wrote:

> On Fri, Jun 06, 2008 at 07:22:25PM +0000, Linux Kernel Mailing List wrote:
> > @@ -1920,23 +2004,16 @@ sub process {
> >  				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
> >  			}
> >  		}
> > -# check for needless usb_free_urb() checks
> > -		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
> > -			my $expr = $1;
> > -			if ($line =~ /\busb_free_urb\(\Q$expr\E\);/) {
> > -				WARN("usb_free_urb(NULL) is safe this check is probabally not required\n" . $hereprev);
> > -			}
> > -		}
> >  
> 
> I'm curious as to why this check was removed.  Any specific reason?  It
> was valid from what I can tell.

Because of the spelling?

If so, let's be consistent:

--- a/scripts/checkpatch.pl~a
+++ a/scripts/checkpatch.pl
@@ -1997,14 +1997,6 @@ sub process {
 				$herecurr);
 		}
 
-# check for needless kfree() checks
-		if ($prevline =~ /\bif\s*\(([^\)]*)\)/) {
-			my $expr = $1;
-			if ($line =~ /\bkfree\(\Q$expr\E\);/) {
-				WARN("kfree(NULL) is safe this check is probabally not required\n" . $hereprev);
-			}
-		}
-
 # warn about #ifdefs in C files
 #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
 #			print "#ifdef in C files should be avoided\n";
_


Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbZC0VL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbZC0VL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757958AbZC0VLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:11:44 -0400
Received: from gw.goop.org ([64.81.55.164]:44858 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757112AbZC0VLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:11:43 -0400
Message-ID: <49CD4109.2070505@goop.org>
Date: Fri, 27 Mar 2009 14:11:37 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Theodore Tso <tytso@mit.edu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org> <20090327051338.GP6239@mit.edu> <20090327055750.GA18065@srcf.ucam.org> <20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu>
In-Reply-To: <20090327112438.GQ6239@mit.edu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> When I was growing up we were trained to *always* check error returns
> from *all* system calls, and to *always* fsync() if it was critical
> that the data survive a crash.  That was what competent Unix
> programmers did.  And if you are always checking error returns, the
> difference in the Lines of Code between doing it right and doing
> really wasn't that big --- and again, back then fsync() wan't
> expensive.  Making fsync expensive was ext3's data=ordered mode's
> fault.

This is a fairly narrow view of correct and possible.  How can you make 
"cat" fsync? grep? sort?  How do they know they're not dealing with 
critical data?  Apps in general don't know, because "criticality" is a 
property of the data itself and how its used, not the tools operating on it.

My point isn't that "there should be a way of doing fsync from a shell 
script" (which is probably true anyway), but that authors can't 
generally anticipate when their program is going to be dealing with 
something important.  The conservative approach would be to fsync all 
data on every close, but that's almost certainly the wrong thing for 
everyone.

If the filesystem has reasonably strong inherent data-preserving 
properties, then that's much better than scattering fsync everywhere.

fsync obviously makes sense in specific applications; it makes sense to 
fsync when you're guaranteeing that a database commit hits stable 
storage, etc.  But generic tools can't reasonably perform fsyncs, and 
its not reasonable to say that "important data is always handled by 
special important data tools".

    J

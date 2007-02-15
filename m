Return-Path: <linux-kernel-owner+w=401wt.eu-S1161560AbXBOWcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161560AbXBOWcv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161562AbXBOWcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:32:51 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:37434 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161560AbXBOWcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:32:51 -0500
Date: Thu, 15 Feb 2007 17:32:50 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sergei Organov <osv@javad.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "J.A. Magall??????n" <jamagallon@ono.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
Message-ID: <20070215223250.GO7584@csclub.uwaterloo.ca>
References: <874pprr5nn.fsf@javad.com> <Pine.LNX.4.64.0702120804520.8424@woody.linux-foundation.org> <87ps8end9b.fsf@javad.com> <84144f020702131026q2af1afd6vbcd2708d7b7b9907@mail.gmail.com> <87bqjxooog.fsf@javad.com> <84144f020702131143r767aa40blb97a39b40bee73b8@mail.gmail.com> <87fy99n6mf.fsf@javad.com> <Pine.LNX.4.64.0702131513050.3604@woody.linux-foundation.org> <87hctnlfqz.fsf@javad.com> <Pine.LNX.4.64.0702150736360.20368@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702150736360.20368@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 07:57:05AM -0800, Linus Torvalds wrote:
> I agree that it's "unnecessary code", and in many ways exactly the same 
> thing. I just happen to believe that casts tend to be a lot more dangerous 
> than extraneous initializations. Casts have this nasty tendency of hiding 
> *other* problems too (ie you later change the thing you cast completely, 
> and now the compiler doesn't warn about a *real* bug, because the cast 
> will just silently force it to a wrong type).

Well one way you could cast it and still have the compiler tell you if
the type ever changes is doing something stupid like:

char* unsigned_char_star_to_char_star(unsigned char* in) {
	return (char*)in;
}

Then call your strlen with:
strlen(unsigned_char_star_to_char_star(my_unfortunate_unsigned_char_string)

If you ever changed the type the compiler would warn you again since the
convertion function doesn't accept anything other than unsigned char *
being passed in for "convertion".  Seems safer than a direct cast since
then you get no type checking anymore.

I hope it doesn't come to this though.  Hopefully gcc will change it's
behaviour back or give an option of --dontcomplainaboutcharstar :)

--
Len Sorensen

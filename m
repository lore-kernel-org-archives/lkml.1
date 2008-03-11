Return-Path: <linux-kernel-owner+w=401wt.eu-S1759118AbYCKVPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759118AbYCKVPg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:15:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbYCKVPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:15:25 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:43088 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756134AbYCKVPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:15:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=gNnpPU+eMzyAwfxCf04RFSRweAD00DDEf4Yp21dy5WcYC/TyX3kjAZ56jPboofd/4ABT7y8KUBOXjZ9AgO/hiAzgF2xIgSYe0bXW6HZnW2kgZa9xamBVviS2/ZAvqxkWIuzrNeS6hRlaDMX5Z4DgM7AHKv42l3fWSXU5NEgDK0Q=
Subject: Re: [PATCH] bitops: add 8-bit and 16-bit rotation functions
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <je1w6hc6yw.fsf@sykes.suse.de>
References: <1205254569.22317.8.camel@brick>
	 <8d55c7ae2d3c851013db4857506b537c@kernel.crashing.org>
	 <je1w6hc6yw.fsf@sykes.suse.de>
Content-Type: text/plain
Date: Tue, 11 Mar 2008 14:15:02 -0700
Message-Id: <1205270102.22317.40.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-11 at 21:59 +0100, Andreas Schwab wrote:
> Segher Boessenkool <segher@kernel.crashing.org> writes:
> 
> >> +/**
> >> + * rol16 - rotate a 16-bit value left
> >> + * @word: value to rotate
> >> + * @shift: bits to roll
> >> + */
> >> +static inline __u16 rol16(__u16 word, unsigned int shift)
> >> +{
> >> +	return (word << shift) | (word >> (16 - shift));
> >> +}
> >
> > This doesn't work for shift values of 0: you get word >> 16, and
> > shifts greater than or equal to the word size aren't valid C.  GCC
> > will warn about this, too.
> 
> On the other hand, a value narrower than int will always be promoted
> first, so this is not a problem in this case.
> 

It's the same way rol32/ror32 is done directly above this section, I saw
this as well, but figured that if checking for shift = 0 was wanted, it
would have been there.

So...don't do that ;-)

Harvey


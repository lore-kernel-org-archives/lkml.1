Return-Path: <linux-kernel-owner+w=401wt.eu-S932361AbYEUApR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbYEUApR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbYEUApE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:45:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:59197 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861AbYEUApD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:45:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ExNcnQqSgSq9vvAEKAImRtXsnJWymHbHY4h/ssXc1v0HpIe4SNGquGIG8U8Z5mDb4P6+/CyrTuNQIjUj0VXQ2BTsjZ2/MzaPMu5RF39MKXiMEn4V5BbdMeRDrMnGnOwfNkV4zMLtw54F+ajGUf23bsFeWdovGPpvWb1setkmn3A=
Subject: Re: [PATCH] bt8xx: unaligned access
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <20080521004306.GC28946@ZenIV.linux.org.uk>
References: <E1JycFh-0004sc-Re@ZenIV.linux.org.uk>
	 <1211330323.5915.226.camel@brick>
	 <20080521004306.GC28946@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Tue, 20 May 2008 17:45:01 -0700
Message-Id: <1211330701.5915.232.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-21 at 01:43 +0100, Al Viro wrote:
> On Tue, May 20, 2008 at 05:38:43PM -0700, Harvey Harrison wrote:
> > > -		type = be16_to_cpup((u16*)(ee+4));
> > > +		type = get_unaligned_be16((__be16 *)(ee+4));
> > 
> > The casts aren't strictly necessary here.  Any reason to keep it?
> 
> I'd rather have them explicit *and* make get_unaligned_* take the pointer
> of right type, so that it'd eat things like void * and __be16 *, but warn
> on int * et.al.  One too many brainos seen in that area...

You want me to patch the unaligned guys to take typed pointers and
follow it through?  Or do you mind?

Cheers,

Harvey


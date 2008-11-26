Return-Path: <linux-kernel-owner+w=401wt.eu-S1755121AbYKZSGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbYKZSGT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 13:06:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbYKZSGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 13:06:08 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:50417 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYKZSGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 13:06:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ep7+uQoqFMTtryNg1JuwkKasHBMv+NgKADe2j/5fZZrMg8/Y8MFLnYqKySMUmYYDg1
         ZRUmFjQWqTaoY6y8wFMw33KRMNzF2WUwSdkapN08Wl2FKyxHqvCES9Q76Yd6jRA2rn5Q
         DYYJpQiLyYUjO4bMOcSlpD+wosAYj4wB3y/WM=
Subject: Re: [PATCH 2/5] ftrace: use code patching for ftrace graph tracer
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20081126100255.d53f9347.akpm@linux-foundation.org>
References: <20081126051622.134970943@goodmis.org>
	 <20081126051709.774546196@goodmis.org>
	 <20081125213546.ff4eddf4.akpm@linux-foundation.org>
	 <alpine.DEB.1.10.0811261144360.26743@gandalf.stny.rr.com>
	 <20081126100255.d53f9347.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 10:06:00 -0800
Message-Id: <1227722760.5511.75.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-26 at 10:02 -0800, Andrew Morton wrote:
> > > 
> > > > +		return -EINVAL;
> > > > +
> > > > +	*(int *)(&code[1]) = new_offset;
> > > 
> > > Might be able to use put_unaligned_foo() here.
> > > 
> > > The problem is that these functions use sizeof(*ptr) to work out what
> > > to do, so a cast is still needed.  A get_unaligned32(ptr) would be
> > > nice.  One which takes a void* and assumes CPU ordering.
> > 
> > Is there a correctness concern here? This is arch specific code, so I'm
> > not worried about other archs.
> 
> No, the code is OK as-is.
> 
> It's just that "read a word from an [maybe-]unaligned address" is such
> a common operation that there should be a nice clean simple function to
> do it, rather than doing open-coded (and different) weird C tricks at each
> and\ every site.
> 

Also it is arch-specific, so if you know unaligned access is OK, just doing the
cast+deref is OK.

Harvey


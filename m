Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbYA1KEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbYA1KEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 05:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYA1KE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 05:04:27 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:23030 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbYA1KEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 05:04:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UNaMK54R/oFFWeawSOzCD0LvejckLKZuG+8iFA6nAJnVP8aWTwFvXZW5bnxcg13eMT1SlQGBzDy+xbOX2mQaVH4k+gUQbj25vihC+7KkWp9wDUSzkpShiS6QuWm1zxqEV7l1dV7LM6WGvHGctz1VUUVYQpkHdV4TB0aMhuhehgU=
Message-ID: <863e9df20801280204j8c5f7bauc37c18f25c95f5a3@mail.gmail.com>
Date: Mon, 28 Jan 2008 15:34:24 +0530
From: "Abhishek Sagar" <sagar.abhishek@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] kprobes: kretprobe user entry-handler (updated)
Cc: LKML <linux-kernel@vger.kernel.org>, jkenisto@us.ibm.com,
       ananth@in.ibm.com, "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <20080127213257.0889c523.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <479B7A78.5090604@gmail.com>
	 <20080127213257.0889c523.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/28/08, Andrew Morton <akpm@linux-foundation.org> wrote:
> Neither the changelog nor the newly-added documentation explain why Linux
> needs this feature.  What will it be used for??

There's a detailed discussion along with an example on this thread:
http://lkml.org/lkml/2007/11/13/58

and a bit on:
http://sourceware.org/ml/systemtap/2005-q3/msg00593.html

The real advantage of this patch is in scenarios where some data (like
function paramters, system time etc) needs to be shared between
function entry and exit. E.g: Viewing the change in system time across
a call to profile it. Here, we have a need to share data between the
entry and exit events of a function call. Also, the correct
association needs to be maintained between the corresponding function
entry-exit pairs. This is already done using a 'return-instance' in
kretprobes. This patch allows these instances to pouch some data as
well. The patch also has a module example which does trivial function
time-duration profiling using entry-handlers. It makes writing
function profilers simpler using kretprobes.

Currently, doing such a thing would require an extra kprobe to be
planted at function entry-point and whose pre-handler must have all
the complexity to do the function entry-exit data association. Also,
using an entry-handler is optional, and is completely backward
compatible.

> > +1.3.2 Kretprobe entry-handler
> > +
> > +Kretprobes also provides an optional user-specified handler which runs
>
> I think "caller-specified" would be a better term here.  Generally "user"
> refers to Aunt Tillie sitting at the keyboard.

Just followed suit from exising kprobes.txt which had quite a few
references to such a 'user'.

Cheerfully Acked by -> Aunt Tillie :-)

--
Thanks,
Abhishek

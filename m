Return-Path: <linux-kernel-owner+w=401wt.eu-S1755253AbZCBWAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbZCBWAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 17:00:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZCBV7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:59:54 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:9678 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbZCBV7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:59:52 -0500
MIME-Version: 1.0
In-Reply-To: <20090302133551.1266f725.akpm@linux-foundation.org>
References: <5aa163d00902282053h38b0febbyb37fc30855fdc985@mail.gmail.com>
	 <20090302130425.23cc628d.akpm@linux-foundation.org>
	 <20090302211820.GA21489@kroah.com>
	 <20090302133551.1266f725.akpm@linux-foundation.org>
Date: Mon, 2 Mar 2009 16:59:48 -0500
X-Google-Sender-Auth: e19394f5d941be4b
Message-ID: <5aa163d00903021359x3a4693f5tbb7f1e3fec4d88b8@mail.gmail.com>
Subject: Re: PATCH [1/3] drivers/input/xpad.c: Improve Xbox 360 wireless 
	support and add sysfs interface
From: Mike Murphy <mamurph@cs.clemson.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
       oliver@neukum.org, fweisbec@gmail.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 2, 2009 at 4:35 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> OK.  I think.
>
> - This approach will require a large number of edits each time an
>  attribute is added/removed.
>
> - otoh, removing nasty macros is always nice.
>
> - This approach will generate slower code (which doesn't matter
>  here).
>
> - Was it demonstrated that this approach generates less code?
>

It should generate less code, as compared to having two functions
(show and store) per attribute, in which each function has about 4
lines and a local variable for the store functions (which is there for
type validation). For both show and store functions, there still has
to be code to get to the struct usb_xpad instance.

As I was coding this interface, I found myself wishing for a
macro-based system like module parameters have. For example, it would
be nice to be able to do something like the following:

DECLARE_SYSFS_INTERFACE(&xpad->dead_zone, uint, &check_dead_zone);

which would create the needed show/store functions that worked with an
unsigned int. The check_dead_zone function would be a validator
function inside the module that would check the validity on a
user-supplied value on store (in this case, to be sure it was at least
1024 below the stick limit) and return an error code if the value were
out of range. Yes, the validator would be an extra function call, but
this code doesn't run in an interrupt context, so the benefit of being
able to centralize the functionality and simplify drivers might be
worth the extra overhead.

Mike
-- 
Mike Murphy
Ph.D. Candidate and NSF Graduate Research Fellow
Clemson University School of Computing
120 McAdams Hall
Clemson, SC 29634-0974 USA
Tel: +1 864.656.2838   Fax: +1 864.656.0145
http://cirg.cs.clemson.edu/~mamurph

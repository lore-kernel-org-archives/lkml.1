Return-Path: <linux-kernel-owner+w=401wt.eu-S1758230AbZASO7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758230AbZASO7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 09:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbZASO7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 09:59:04 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:10606 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbZASO7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:59:02 -0500
Message-ID: <154e089b0901190659g2a836fa0o6cbedd0396fef11c@mail.gmail.com>
Date: Mon, 19 Jan 2009 15:59:00 +0100
From: "Hannes Eder" <hannes@hanneseder.net>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Subject: Re: [PATCH] creds: suppress warning in get_cred
Cc: "David Howells" <dhowells@redhat.com>, "James Morris" <jmorris@namei.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090120015251.47ea14ff.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20090119211031.934b4c19.sfr@canb.auug.org.au>
	 <11956.1232368171@redhat.com>
	 <20090120015251.47ea14ff.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 3:52 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi David,
>
> On Mon, 19 Jan 2009 12:29:31 +0000 David Howells <dhowells@redhat.com> wrote:
>>
>> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> > +   return get_new_cred((struct cred *)(uintptr_t)cred);
>>
>> That should probably be 'unsigned long' within the kernel.  This is also a
>> compiler bug, but I think we can live with this fix.
>
> We do have uintptr_t inside the kernel (it is typedeffed to unsigned
> long) but I used it explicitly because its type is defined to be large
> enough to store any pointer.

When working around this compiler bug would it be better to do it like this:

+     return get_new_cred((struct cred *)(void *)cred);

instead of relying on the size of a pointer and using an large enough
integer data type?

Maybe would should just add a comment, to note that if such a warning
is issued, that
this is a compiler bug.

Or disable the warning for this region, but as far as I know gcc _does
not_ have this feature yet.

> However, I have also verified that using a newer compiler (4.3.2 in my
> case) makes the warning go away as Hannes Eder pointed out when
> mentioning his earlier patch.

Hannes

Return-Path: <linux-kernel-owner+w=401wt.eu-S1759203AbZA2EVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203AbZA2EVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 23:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbZA2EVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 23:21:22 -0500
Received: from blaine.gmane.org ([80.91.229.8]:42542 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464AbZA2EVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 23:21:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=fGS39qWSMhBZFTBGNL7MOXT0T/9KY678ubxRkFyVtU0B447rJU6/oHLrXFT4NJ8idG
         dtfZ4+FMjrGiWxzxJ2xCB+n11AoR2MySALZuDxYDpt53zIzNePGAlbxAS3Sjgrd2rFWd
         AXltDVuvUrSy6h8xyfZjvolHkZGQ1u//1qPys=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20090129011758.GA26534@kroah.com>
References: <20090128213322.GA15789@kroah.com> <4980FB4D.9090009@shaw.ca>
	 <20090129011758.GA26534@kroah.com>
Date: Thu, 29 Jan 2009 15:59:12 +1300
Message-ID: <cfd18e0f0901281859u250f202fj3ef40fb8531f1dc3@mail.gmail.com>
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Greg KH <greg@kroah.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       Greg KH <public-greg-U8xfFu+wG4EAvxtiuMwx3w@hugh.gmane.org>,
       public-mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org,
       public-linux-man-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
       public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TMDA-Confirmed: Thu, 29 Jan 2009 05:21:05 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Thu, Jan 29, 2009 at 2:17 PM, Greg KH <greg@kroah.com> wrote:
>
>
>
> On Wed, Jan 28, 2009 at 06:41:49PM -0600, Robert Hancock wrote:
>>
>>
>> Greg KH wrote:
>>> In looking at open(2), it says that O_DIRECT works on 512 byte boundries
>>> with the 2.6 kernel release:
>>>      Under Linux 2.4, transfer sizes, and the alignment of the user
>>>      buffer and  the file offset must all be multiples of the logical
>>>      block size of the file system.  Under Linux 2.6, alignment  to
>>>      512-byte  boundaries suffices.
>>> However if you try to access an O_DIRECT opened file with a buffer that
>>> is PAGE_SIZE aligned + 512 bytes, it fails in a bad way (wrong data is
>>> read.)
>>> Is this just a mistake in the documentation?  Or am I reading it
>>> incorrectly?
>>> I have a test program that shows this if anyone wants it.
>>
>> Well, it sounds like a bug to me.. even if it's not supported, if you do
>> such an access, surely the kernel should detect that and return EINVAL or
>> something rather than reading corrupted data..
>
> It doesn't.  It says the read is successful, yet the data is not really
> read into the buffer.  Portions of it is, but not the amount we asked
> for.

Greg,

Can you post your test program?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html



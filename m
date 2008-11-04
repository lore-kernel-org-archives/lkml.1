Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbYKDQVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbYKDQVq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 11:21:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbYKDQVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 11:21:36 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:17726 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411AbYKDQVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 11:21:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references
         :in-reply-to:content-type:content-transfer-encoding:from;
        b=fARW84KOjnOFGcfA9A3BZVRNKmdi7GtHdjkYkANxXsRYJzGKC3MdWmmwr+dF+cUN6p
         YRC13szjdBm8LToVpKu4Q+yPrlYS/9PJJaV/I8zZBclBBi12485L8pal2VDTpU2COTxI
         WHHj2c35MdlTBXbgyvyJqE9BVpZnMLS/IHeCU=
Message-ID: <49107656.2060101@gmail.com>
Date: Tue, 04 Nov 2008 11:20:38 -0500
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Daniel Gollub <dgollub@suse.de>
CC: Kai Henningsen <kai.extern@googlemail.com>, mtk.manpages@googlemail.com,
       linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
       linux-man@vger.kernel.org, ltp-list@lists.sourceforge.net,
       "A.E. Brouwer" <aeb@win.tue.nl>
Subject: Re: [patch 0/3] [RFC] kernel/glibc mismatch of "readlink" syscall?
References: <20081023145054.998439866@marvin.suse.de> <cfd18e0f0810241553x77194611o11655a89871dc210@mail.gmail.com> <20081031160248.2b95d0e8@desktop.khms.westfalen.de> <200810311637.25371.dgollub@suse.de>
In-Reply-To: <200810311637.25371.dgollub@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel,

Daniel Gollub wrote:
> On Friday 31 October 2008 16:02:48 Kai Henningsen wrote:
>> Am Fri, 24 Oct 2008 17:53:25 -0500
>>
>> schrieb "Michael Kerrisk" <mtk.manpages@googlemail.com>:
>>> Hi Daniel,
>>>
>>> On Thu, Oct 23, 2008 at 9:50 AM, Daniel Gollub <dgollub@suse.de>
>>>
>>> wrote:
>>>> EINVAL bufsiz is not positive.
>>> The EINVAL error was added to man-pages-1.18 in 1997 (even though, as
>>> you note, the type was "size_t").  I suspect (this was well before I
>>> had any association with man-pages) that was done to reflect kernel
>>> reality (since one could bypass glibc invoke the syscall directly),
>>> but obviously it is inconsistent with the prototype.
>> Actually, it's not inconsistent as described, though perhaps that is
>> unintentional. "Not positive" isn't the same as "negative", as zero
>> isn't positive either, and zero is certainly a possible value of an
>> unsigned type
> 
> True.

So, at this stage I don't plan to make any change to man-pages.
(Let me know if you think this is the wrong course.)

> But there is still the problem for the ltp syscall test "readlink03", when 
> using the glibc "readlink" interface, by calling readlink with a buffer size 
> of "-1".
> 
> Calling "-1" seems to be a valid code/error-path in the linux syscall 
> "readlink", since there is a check for less-equal zero.
> 
> But the less zero, condition can't be reached via the glibc "readlink" 
> interface since this would cause fortify-check to fail (when buliding with -
> D_FORITFY_SOURCE=2).
> 
> To "workaround" the fortify check, by not compiling the testcase with -
> D_FORTIFY_SOURCE=2, or trying to test the linux readlink interface by calling 
> directly syscall() in the testcase ... both suggestion are just workarounds - 
> no real solutions.
> 
> We could also just remove the testcase of buffer size "-1".
> 
> The problem is still, how to test the "readlink" syscall in LTP?

I'd say: remove this test.  And add one for bufsiz==0 if there isn't one
already.

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

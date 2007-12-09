Return-Path: <linux-kernel-owner+w=401wt.eu-S1753443AbXLIHAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbXLIHAV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 02:00:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750948AbXLIHAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 02:00:09 -0500
Received: from rv-out-0910.google.com ([209.85.198.190]:30756 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbXLIHAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 02:00:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CuJsTFSSr+3lDeNFFu/TW+if4l9SzgG1/v8CQMpYRjgPZjIu9t2va0jvcVspdRcp3FYdceZK+tsLaG40OkyDdK/kezPWhsojrMmmGwfCoqGvHjK6314+lMqNFRK+LxnsCVEO1Ci1U3hKYPvV2l7ZTUXTIjagIRa14qeekfZ5bhM=
Message-ID: <475B9270.6070902@gmail.com>
Date: Sun, 09 Dec 2007 16:00:00 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
References: <200712080340.49546.rjw@sisk.pl> <20071208015227.3a1c7fae.akpm@linux-foundation.org>
In-Reply-To: <20071208015227.3a1c7fae.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, (cc'ing Alan)

Andrew Morton wrote:
>> Subject		: cd/dvd inaccessible in 2.6.24-rc2
>> Submitter	: Will Trives <will@trivescon.com.au>
>> References	: http://lkml.org/lkml/2007/11/9/290
>> 		  http://bugzilla.kernel.org/show_bug.cgi?id=9346
>> Handled-By	: Len Brown <lenb@kernel.org>
>> 		  Tejun Heo <htejun@gmail.com>
>> Patch		: 
>>
> 
> Nasty one.  Tejun and several diligent reporters are doing sterling
> work there and things have improved.  I don't know whether any of
> Tejun's patches have been merged yet, but we'll probably be OK on
> this one.

I'm still trying to find out what's really going on.  That drive is
quite peculiar.

> What is unclear (to me) is what actually caused those people's machines to
> break?

It's introduced by setting ATAPI transfer chunk size to actual
transfer size which is the right thing to do generally.  However, with
the change, the ATAPI HSM should be ready to drain full extra transfer
chunks which libata HSM wasn't doing.  With that part changed, most
regressions should go away.

Unfortunately, simply adding that doesn't fix the case in bug 9346 and
I'm still trying to find out why.  The good news is that the drive
works fine with proposed more extensive improvements to libata ATAPI
which will probably be included into 2.6.25, so we at least have long
term solution.

If we fail to find out the solution in time, we always have the
alternative of backing out the ATAPI transfer chunk size update.  This
will break some other cases which were fixed by the change but those
won't be regressions at least and we can add transfer chunk size
update with other changes to 2.6.25.

Thanks.

-- 
tejun

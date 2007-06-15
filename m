Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbXFOHQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbXFOHQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 03:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbXFOHQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 03:16:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:28909 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXFOHQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 03:16:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=il1EppkBV5rtZbP0VupL8Ywy1tPdJPIz6vpPybSpV9IZi4ZslokLyAAvhX+Qe+sdX7TslpGx8QOtqoN9HZ2eBkl1US9L5ePL+kn0FCIm02CSweZLs5ziEBlSmOeFRMGKXDrF9bVwqi/1mm31CVMK/FynV8v2XqYi4Due8qq15PA=
Message-ID: <787b0d920706150016n3e941a4fj4fc2e864a7e6f7d7@mail.gmail.com>
Date: Fri, 15 Jun 2007 03:16:26 -0400
From: "Albert Cahalan" <acahalan@gmail.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       takedakn@nttdata.co.jp, hch@infradead.org
Subject: Re: [TOMOYO 5/9] Memory and pathname management functions.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig writes:
> On Thu, Jun 14, 2007 at 04:36:09PM +0900, Kentaro Takeda wrote:

>> We limit the maximum length of any string data (such as
>> domainname and pathnames) to TOMOYO_MAX_PATHNAME_LEN
>> (which is 4000) bytes to fit within a single page.
>>
>> Userland programs can obtain the amount of RAM currently
>> used by TOMOYO from /proc interface.
>
> Same NACK for this as for AppArmor, on exactly the same grounds.
> Please stop wasting your time on pathname-based non-solutions.

This issue is a very very small wart on an otherwise fine idea.
It's really not worth getting bothered by. Truth is, big giant
pathnames break lots of stuff already, both kernel and userspace.

Just look in /proc for some nice juicy kernel breakage:
cwd, exe, fd/*, maps, mounts, mountstats, root, smaps

So, is that a NACK for the /proc filesystem too? :-)

We even limit filenames to 255 chars; just the other day
a Russian guy was complaining that his monstrous filenames
on a vfat filesystem could not be represented in UTF-8 mode.

Both TOMOYO and AppArmor are good ideas. At minimum, one of
them ought to be accepted. My preference would be TOMOYO,
having origins untainted by Novell's Microsoft dealings.

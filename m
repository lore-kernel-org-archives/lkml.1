Return-Path: <linux-kernel-owner+w=401wt.eu-S1752530AbZGWF0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbZGWF0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 01:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752036AbZGWF0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 01:26:48 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:62229 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbZGWF0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 01:26:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c8a+iy/5WM2K1PEUKkQwgGvvFks96PM+4CruJcSgeCAgMg0UV+d3+IJF6DrzEjitFA
         7CjqHxpB88mCsKS2q4J9LPP1OvLdrN6kJhkDWrP6EfYNvNjcJv9hOoD57whpaGDh5h8V
         mhVIE0VRQUGEdmEBvFHrJuHEd1o8wrLO82xvo=
MIME-Version: 1.0
In-Reply-To: <20090722161312.8c2ab4b5.akpm@linux-foundation.org>
References: <62.47.75.132.1247818962.wm@webmail.inode.at>
	 <20090722161312.8c2ab4b5.akpm@linux-foundation.org>
Date: Thu, 23 Jul 2009 07:26:46 +0200
Message-ID: <d8bd05e00907222226o369fe2e7i225afb06ec71db8d@mail.gmail.com>
Subject: Re: mounting cifs filesystems not possible
From: Gerhard Hintermayer <gerhard.hintermayer@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: sfrench@samba.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well this is indeed strange. First I thought the problem was solved
because I had an old version of mount installed, but the successful
mount with latest version of mount.cifs was only by chance. I get 1
successful mount out of ~ 30 tries (each time unloading the cifs
module). And looking at the source in export.c I discovered, that
reexporting cifs- mount points is still not supported :-( : This seems
to be very tricky. If you need more information to track the tainting
problem down, pls give me a note.


PS: please CC gerhard.hintermayer@gmail.com, I'm not on the list

On Thu, Jul 23, 2009 at 1:13 AM, Andrew Morton<akpm@linux-foundation.org> wrote:
> On Fri, 17 Jul 2009 10:22:42 +0200 (CEST)
> "Gerhard Hintermayer" <g.hintermayer@inode.at> wrote:
>
>> I discovered that this is a slow_path issue, which is tainting the kernel,
>> I already filed this as a gentoo bug, but since this is kernel related, I
>> think here's the right place.  The server I'm trying to mount is a Windows
>> 2003 Server, I  can inquire more if neccessary.
>> PS: please CC me, I not on the list anymore (too much traffic, just how I
>> was warned)
>>
>
> please do cc the CIFS maintainer and list on future issues:
>
> COMMON INTERNET FILE SYSTEM (CIFS)
> P:      Steve French
> M:      sfrench@samba.org
> L:      linux-cifs-client@lists.samba.org
> L:      samba-technical@lists.samba.org
> W:      http://linux-cifs.samba.org/
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
> S:      Supported
> F:      Documentation/filesystems/cifs.txt
> F:      fs/cifs/
>
> Thanks.
>

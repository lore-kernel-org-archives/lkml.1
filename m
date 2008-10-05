Return-Path: <linux-kernel-owner+w=401wt.eu-S1753899AbYJEGA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbYJEGA6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 02:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbYJEGAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 02:00:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:61201 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbYJEGAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 02:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Qp46ETBlj0aAo4wcm1jeQYfcCXMiX+L8s/XVQ45RpmJMWNRKKieFchUgGnRHLrQEfs
         4iMKHuOJ1ctsjDNqHWeQjNb2lVvlye9ooJLIRkfavg3TdIWOb0SO/EZXqOnH9NAPYG63
         JjeA5s0LYmpwucg0QCIAiy4m8XAIIFL1GeV4I=
Message-ID: <2f11576a0810042300t26b3556ax304771b4f893468@mail.gmail.com>
Date: Sun, 5 Oct 2008 15:00:49 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH 2/2] Report the pagesize backing a VMA in /proc/pid/maps
Cc: "Mel Gorman" <mel@csn.ul.ie>, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081004221339.GA20175@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223052415-18956-1-git-send-email-mel@csn.ul.ie>
	 <1223052415-18956-3-git-send-email-mel@csn.ul.ie>
	 <20081004221339.GA20175@x200.localdomain>
X-Google-Sender-Auth: 83b8e468f215bf36
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

>> This patch adds a new field for hugepage-backed memory regions to show the
>> pagesize in /proc/pid/maps.  While the information is available in smaps,
>> maps is more human-readable and does not incur the cost of calculating Pss. An
>> example of a /proc/self/maps output for an application using hugepages with
>> this patch applied is;
>>
>> 08048000-0804c000 r-xp 00000000 03:01 49135      /bin/cat
>> 0804c000-0804d000 rw-p 00003000 03:01 49135      /bin/cat
>> 08400000-08800000 rw-p 00000000 00:10 4055       /mnt/libhugetlbfs.tmp.QzPPTJ (deleted) (hpagesize=4096kB)
>
>> To be predictable for parsers, the patch adds the notion of reporting on VMA
>> attributes by appending one or more fields that look like "(attribute)". This
>> already happens when a file is deleted and the user sees (deleted) after the
>> filename. The expectation is that existing parsers will not break as those
>> that read the filename should be reading forward after the inode number
>> and stopping when it sees something that is not part of the filename.
>> Parsers that assume everything after / is a filename will get confused by
>> (hpagesize=XkB) but are already broken due to (deleted).
>
> Looks like procps will start showing hpagesize tag as a mapping name
> (apologies for pasting crappy code):

Administrator expect mapping name is just file name when vma is
hugepage via mmap.
So, I feel Mel's code is nicer.

Thanks.

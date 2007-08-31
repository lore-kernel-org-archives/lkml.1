Return-Path: <linux-kernel-owner+w=401wt.eu-S966238AbXHaSsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966238AbXHaSsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 14:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965954AbXHaSsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 14:48:07 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:11293 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965945AbXHaSsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 14:48:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:references:in-reply-to:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=W7OpdyzizDmweEeevDy5N1e4RcOd/Abu3c9sO8zRVYiZJJRMz5q7zm5HrGHWb3t56BqXC+d+Uf13GYxueb/AGYcUZBEE1jYGrlayJGAZV5UdV3pqIK5ooD5X7ugIrECq513fbSjNwJeOagSIw+VwFYOBELujrtcGgUmpvtnzDA0=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Trond Myklebust'" <trond.myklebust@fys.uio.no>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: "'Frank van Maarseveen'" <frankvm@frankvm.com>,
       "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>
References: <000701c7eb49$cff701c0$6fe50540$@com>	 <1188513433.6626.24.camel@heimdal.trondhjem.org>	 <alpine.LFD.0.999.0708302038310.25853@woody.linux-foundation.org> <1188577275.6649.133.camel@heimdal.trondhjem.org>
In-Reply-To: <1188577275.6649.133.camel@heimdal.trondhjem.org>
Subject: RE: recent nfs change causes autofs regression
Date: Fri, 31 Aug 2007 11:47:52 -0700
Message-ID: <006a01c7ebff$709354c0$51b9fe40$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acfr6vnZDkrKhs2lRVmpchuW/awT/QAE9vrg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the problem for me, thanks.

Is this patch changing the behavior of "sharecache" to
"try-to-share-cache-if-possible", or adding a third behavior? If the user
explicitly asks for "-o sharecache", does he get an error back if the mount
options mismatch?
 
> The best I can do given the constraints appears to be to have the
> kernel first look for a superblock that matches both the fsid and the
> user-specified mount options, and then spawn off a new superblock if
> that search fails. The attached patch does just that.
> 
> Note that this is not the same as specifying nosharecache everywhere
> since nosharecache will never attempt to match an existing superblock.
> 
> Finally, for the record: I still feel very uncomfortable about not
> being able to report the state of the client setup back to the sysadmin.
> AFAIK, the only way to do so is to stat the mountpoints, and compare
> the device ids.
> 
> Trond



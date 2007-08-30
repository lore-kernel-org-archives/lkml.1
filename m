Return-Path: <linux-kernel-owner+w=401wt.eu-S1762651AbXH3VIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762651AbXH3VIK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 17:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758259AbXH3VHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 17:07:54 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:64945 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712AbXH3VHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 17:07:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:content-language;
        b=OBZwb30hTnZ/Ll8Fv2JgJokl5luZBXMcp/oyEOPufjxRPtgJFyqWuUzLckTRZAU59NXiEy9lxPxyapMu0WcNzzIje7DbpiIG07VtaiOk/Aid2XoxE8I+EMCOBlAlatC1NDFMgYJUz4lDquJM24VXk56rasVyWSkmP4l5f1viCpo=
From: "Hua Zhong" <hzhong@gmail.com>
To: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Cc: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
       <akpm@linux-foundation.org>
Subject: recent nfs change causes autofs regression
Date: Thu, 30 Aug 2007 14:07:43 -0700
Message-ID: <000701c7eb49$cff701c0$6fe50540$@com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acfqf2fhopQVT2kOSOCYqFO/cJ34rQAyPAGg
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I am re-sending this after help from Ian and git-bisect. To me it's a
show-stopper: I cannot find an acceptable workaround that I can implement.

The problem: upgrading to 2.6.23-rc4 from 2.6.22 causes several autofs
mounts to fail silently - they just not appear when they should.

I believe it's caused by the NFS change that forces multiple mounts from
different directories under the same server side filesystem to have the same
mount options by default, otherwise it returns EBUSY.

For example, if server has a filesystem /a, and it exports /a/x and /a/y
(maybe with rw or ro), and a client must mount /a/x and /a/y with the same
mount options now.

Since in my setup they are managed by autofs, and the autofs map is managed
by nis, there is no way I could easily workaround it..

If we have to live with this regression, I want to hear some suggestions
about how to fix them realistically. Thanks.

By the way, I am not sure if I did the bisect right, but FWIW, git-bisect
says:

c98451bdb2f3e6d6cc1e03adad641e9497512b49 is first bad commit
commit c98451bdb2f3e6d6cc1e03adad641e9497512b49
Author: Frank van Maarseveen <frankvm@frankvm.com>
Date:   Mon Jul 9 22:25:29 2007 +0200

    NLM: fix source address of callback to client

    Use the destination address of the original NLM request as the
    source address in callbacks to the client.

    Signed-off-by: Frank van Maarseveen <frankvm@frankvm.com>
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

:040000 040000 675c84bd8b2c50744018becaa0db4aeca19b8f9f
105fbd3cb3fa5e3019836b4b5268125d0181a72d M      fs
:040000 040000 0138796e0806b4ebd1cc3850ed4e8c7ab24d2d41
2fec08debe51c20423a88b1a0d4281c683ba5daf M      include


-----Original Message-----
From: Hua Zhong [mailto:hzhong@gmail.com] 
Sent: Wednesday, August 29, 2007 1:59 PM
To: 'Linux Kernel Mailing List'
Subject: regression of autofs for current git?

Hi,

I am wondering if this is a known issue, but I just built the current git
and several autofs mounts mysteriously disappeared. Restarting autofs could
fix some, but then lose others. 2.6.22 was fine.

Is there anything I could check other than bisect? (It may take some time
for me to get to it)

Thanks for your help.

Hua


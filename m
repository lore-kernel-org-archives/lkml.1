Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYGEBHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYGEBHT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 21:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYGEBHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 21:07:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:54598 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYGEBHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 21:07:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=kEpMvlBX2czCGPZtkGgetkMh1fmlUlX4X2udioXrTd5ZOrBcYEO2eQXrdAPoORG/+p
         Nf5HAETbnDJC3asm8ampxr+JyhxNsuXFzytMiCMbPlMFFbmN1wqHjTBohSeSyXYJfXkH
         mN4RZ7csLOxqmbBgfSkU6Tolu/9U4ZeSwSkrg=
Message-ID: <b6fcc0a0807041807p24cce461m419d7b54fce72d34@mail.gmail.com>
Date: Sat, 5 Jul 2008 05:07:02 +0400
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: torvalds@osdl.org
Subject: *sigh* /proc/*/pagemap
Cc: akpm@osdl.org, mpm@selenic.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm few days from my patch-sending facility, but could someone
_please_ do the following before release:

1) initialize pagemap_walk.mm to "mm" , so the code starts working as
advertised, and
2) also initialize ->private to "&pm" so it wouldn't immediately oops
in pagemap_pte_hole(), and
3) unstatic struct pagemap_walk, so two threads won't fsckup each other
   (including those started by root, including flipping ->mm when you
don't have permissions),
    and
4) remove second ptrace_may_attach(), and
5) check with microscope allocation there -- page-aligned address and size == 0
    should allocate 0 bytes, and
6) actually check that it works.

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbZK1Sxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbZK1Sxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 13:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbZK1Sxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 13:53:49 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:53300 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZK1Sxs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 13:53:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qErAmMshGvZg5JyPTemuSnR3Dew5iAMQYlTF1Gi1ipWTTzmRigKyvacZQqra14cQEb
         racVKQslmzf2bS5FnBtANvx6TCdb9iCTY5g49Y4aGwYtwSXr7KlhFOD+hVuRdZojnJAK
         ZUH741ioRya2p78SXV5a6D8NNEkrvWbo1zg+g=
MIME-Version: 1.0
In-Reply-To: <8bd0f97a0911280740p24ad49bal64b924a427abfa39@mail.gmail.com>
References: <8bd0f97a0911280740p24ad49bal64b924a427abfa39@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 28 Nov 2009 13:53:35 -0500
Message-ID: <8bd0f97a0911281053x4299e783lc22e63d15170b27d@mail.gmail.com>
Subject: Re: avoiding duplicate icache flushing of shared maps on nommu
To: David Howells <dhowells@redhat.com>, Paul Mundt <lethal@linux-sh.org>,
       Bernd Schmidt <bernds_cb1@t-online.de>,
       Jie Zhang <jie.zhang@analog.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 10:40, Mike Frysinger wrote:
> when working with FDPIC, there are many shared maps of read only text
> regions (the C library, applet packages like busybox, ...) between
> applications.  but the current mm/nommu.c:do_mmap_pgoff() function
> will issue an icache flush whenever a vma is added to a mm instead of
> only doing it when the map is initially created.  am i missing
> something obvious here, or would a change like below be OK ?  this
> easily cuts the number of icache flushes during boot by 50% if not
> more.

for some actual numbers, my default boot iflushes 18,562,124 bytes.
with this fix, it's down to 4,528,580 bytes (a 75% shrink).  with the
stack fix, it's down to 989,636 bytes (a 95% shrink).
-mike

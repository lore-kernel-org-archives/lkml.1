Return-Path: <linux-kernel-owner+w=401wt.eu-S932462AbXIAWuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbXIAWuk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 18:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751503AbXIAWub
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 18:50:31 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:55298 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXIAWua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 18:50:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fme88MAEqK+8oAJSFy1s3pZg+EtRXLsIEMhNFN3hFL+6JdXVeemFef+NZ1kMWQmPFqsj+MRVlPfNT7PKKlLgHCl970ROJgQXsCAnv21rt/BF/9qRgsIcyVxvC/GWk5i+1dup/yRgJmSYV6ApB0Msx1mrhML53uDRA2qOuF5mKxY=
Message-ID: <8bd0f97a0709011550y833fb5ax7d40cae937789fd8@mail.gmail.com>
Date: Sat, 1 Sep 2007 18:50:30 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: the Linux kernel, testsuites, and maybe *you*
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <p733axyxcli.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0708311422u309ff09cs24dfe64ff535a982@mail.gmail.com>
	 <p733axyxcli.fsf@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 02 Sep 2007 00:08:57 +0200, Andi Kleen <andi@firstfloor.org> wrote:
> BTW string functions are best tested in user space. That's
> a relatively bad example.

in theory, maybe ... in reality, i really dont think so

the string implementations are spread out over the kernel ... there's
implementations in lib/, include/asm-*/, and arch/*/lib/ ... so any
test code that would use these sources is going to be an ugly hack to
make sure it grabs all the right pieces from all the right places.

then there's the issue of API ... compiling code that is designed to
be in the kernel and nowhere else is going to require a mighty bit of
crappy glue logic in order for it to compile properly in userspace

but let's cheat and just use the kernel build system to produce .o's
for us ... then there's the issue of ABI.  there is no guarantee the
ABI the kernel uses internally is the same as the ABI userspace uses
(and in fact, on some architectures it is simply not possible).  so
you're left with a solution that may work for some, but not for
others.

or we put one common piece of C test code right into the kernel and be
done.  no worrying about the tested API/ABI/environment being
different from the actual runtime the kernel itself has.
-mike

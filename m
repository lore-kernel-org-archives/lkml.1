Return-Path: <linux-kernel-owner+w=401wt.eu-S1764462AbYA2Ry0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764462AbYA2Ry0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:54:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYA2RyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:54:17 -0500
Received: from gw.goop.org ([64.81.55.164]:54142 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbYA2RyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:54:16 -0500
Message-ID: <479F6845.1070902@goop.org>
Date: Tue, 29 Jan 2008 09:54:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ian Campbell <ijc@hellion.org.uk>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: PATCH/RFC: bzImage payload as compressed ELF file.
References: <1201560133.17053.36.camel@cthulhu.hellion.org.uk>	 <479E5D22.1070109@goop.org> <1201599251.5301.26.camel@localhost.localdomain>
In-Reply-To: <1201599251.5301.26.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Campbell wrote:
> If you strip of setup_sects (+1?) from a bzImage, which I think is what
> you are referring above, then you end up with essentially
> arch/x86/boot/compressed/vmlinux (at address 0x100000 from one of the
> bzImage header fields) which can still be jumped to by a 32 bit
> bootloader. It will decompress and process the ELF bits correctly. I
> think this is where my patch differs from your previous version, you
> made the actual compressor portion an ELF file within the bzImage.
>   

Yes, that's right.  The changes to make it work were a fair bit more 
complex than your's.

> The thing which no longer works here is scanning the whole image looking
> for a gzip header just past setup_sects and extracting that expecting to
> find a raw binary because you will actually find an ELF file. I'm not
> sure that's an "interface" which could be expected to continue to work
> for all time anyway.
>   

Who does that?

> That's what I figured. There will be some build system pain to extract
> those offsets from boot/compressed/vmlinux and incorporate them into
> boot/bzImage but I'll figure something out.
>   

I solved that with some linker magic.  One of the things I did was get 
rid of tools/build and did everything in the linker.  And I worked out a 
trick where you can get the setup code to refer to vmlinux's symbols 
without actually linking it in (no, wait, was that to solve something 
else?).

In the xenbits repo, you can see a series of patches guarded with 
+pvboot, which was my patchset when I last worked on it. 
i386-cleanup-image-generation.patch is particularly interesting (though 
it could definitely do with being broken into smaller patches).  
(xen-paravirt-boot.patch was fun to get going too, though I don't think 
it will be useful overall.)


    J

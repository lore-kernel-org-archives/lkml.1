Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbXBFPuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbXBFPuV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 10:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932606AbXBFPuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 10:50:21 -0500
Received: from terminus.zytor.com ([192.83.249.54]:55419 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518AbXBFPuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 10:50:20 -0500
Message-ID: <45C8A3B3.6000802@zytor.com>
Date: Tue, 06 Feb 2007 07:50:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: vgoyal@in.ibm.com, Etienne Lorrain <etienne_lorrain@yahoo.fr>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Compressed ia32 ELF file generation for loading by Gujin
 1/3
References: <522909.27613.qm@web26909.mail.ukl.yahoo.com>	<45C7CDD7.20806@zytor.com> <20070206052514.GA15613@in.ibm.com>	<45C81D5B.3050408@zytor.com> <20070206063320.GA26462@in.ibm.com>	<45C82266.3010007@zytor.com> <20070206065104.GB26462@in.ibm.com> <m1abzrvjdj.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1abzrvjdj.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> Just for documentation the current interface is you come in through
> the kernels 16bit entry point and get all of it's BIOS calls, or your
> bootloader is responsible for getting the equivalent information
> somehow.
> 
> From what little I skimmed part of what Gujin wanted to do was sane
> at first glance. Just boot a gziped vmlinux like the other
> architectures.  The problem was the 16bit code.  
> 
> So there may be some good ideas buried in there somewhere, but it
> likely to take some doing, and patches that I have to save before
> I read them are a real pain!
> 

Actually, as far as I can see, he has re-invented having a real-mode 
code chunk which then gets run before the protected-mode kernel.  We 
already have that!  You can even intercept between running real-mode and 
protected-mode if you really want to.

I don't really see anything new here.  The one thing that he does which 
we might want to consider emulating is writing the real-mode code in C. 
  Right now, the assembly code is very cluttered, and with the size 
limit having been, long ago, raised from 2K to 32K we should be able to 
fit a fair bit of code even if we use C.

	-hpa

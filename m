Return-Path: <linux-kernel-owner+w=401wt.eu-S1757191AbYHHLUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbYHHLUS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754600AbYHHLUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:20:04 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:15308 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbYHHLUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:20:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=hzFsKc9s5cxKYQNGKkiFhlAKwOUoeMYve0XFLOsqXC3S/mVdZUWKMoWd1zmqv3cggr
         CBQRA+16YFBquu9zyY/TDpmCcwEWkwHE3bdP++xcThx8lG86PQ3PFRNfDdDJC9PKpmJ+
         Yt8279k4ymZn5p+ADZU/ko5FXUiU37NEwPs74=
Message-ID: <489C2BBE.8040600@tuffmail.co.uk>
Date: Fri, 08 Aug 2008 12:19:26 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bzolnier@gmail.com, linux-ide@vger.kernel.org, jgarzik@pobox.com,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Linux 2.6.27-rc2] suspend to disk, libata problem
References: <8db1092f0808071530o2f41b1b9p227dbb920e0a3961@mail.gmail.com>	 <alpine.LFD.1.10.0808071541150.3462@nehalem.linux-foundation.org>	 <200808080052.03443.rjw@sisk.pl> <8db1092f0808080057n588fff24r940b20358f5869f3@mail.gmail.com>
In-Reply-To: <8db1092f0808080057n588fff24r940b20358f5869f3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> Thanks
> s2disk works, but I notice other problem during resume and normal
> booting. Kernel very often stoped booting while detect PATA drive (DVD
> drive):
> http://unixy.pl/maciek/download/kernel/2.6.27-rc2/msi_path/img_0008.jpg
> 
> On 2.6.25.* stable it never happen.
> On 2.6.26-rc* and 2.6.26.* stable -  sometimes
> On 2.6.27-rc* - very often
> 
> So I try disable CONFIG_IDE and test s2disk again. Problem seems has
> gone But a I have many warnings during resume (USB related?):
> http://unixy.pl/maciek/download/kernel/2.6.27-rc2/without_config_ide/dmesg_resume_ahci.txt

That looks like <http://bugzilla.kernel.org/show_bug.cgi?id=11263>.

Comment  #9 From Alan Stern 2008-08-07 07:30:17  [reply] -------  
This is a known problem caused by changes to the driver core.  I haven't had
time yet to update the USB suspend/resume infrastructure to match.

> Config kernel without CONFIG_IDE:
> http://unixy.pl/maciek/download/kernel/2.6.27-rc2/without_config_ide/config-2.6.27-rc2
> 
> 
> @Linus
> If anybody tells me how do it, why not. I'm not kernel programmer (or
> programmer in  generality). I'm only Linux user - newbie - who found
> problem in kernel and think that better report it before stable 2.6.27
> will be released than after.
> 
> Regards


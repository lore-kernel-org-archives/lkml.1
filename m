Return-Path: <linux-kernel-owner+w=401wt.eu-S1423037AbXDXTLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423037AbXDXTLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423038AbXDXTLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:11:06 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:36249 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423037AbXDXTLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:11:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=U9bFa4jvynMy2ng1RaI6xRf3Y8ZDZlDVwzR600BV2UqFP3dYGqRz7HfbTyRXP3/3xyfDdLWQwXcWpNCWm6SHoPS8/wTQnz53aC1NZUjrfLORvUEKokOLp13ivfindysomw/lWuUIWFVMHctdCLwCa6skU4AI9tunvUvG1IBq12k=
Message-ID: <62eb359a0704241211i2effccc8r9a1d352281b6cbd7@mail.gmail.com>
Date: Tue, 24 Apr 2007 14:11:01 -0500
From: "Marcos Pinto" <markybob@gmail.com>
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: 2.6.20.7 locking up hard on boot
Cc: "Adrian Bunk" <bunk@stusta.de>, linux-pci@atrey.karlin.mff.cuni.cz,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       "Alan Cox" <alan@redhat.com>, "Greg KH" <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <62eb359a0704231558we55f553u44a77183ed3e5340@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <62eb359a0704201747ma376567kda671d6fa98b7409@mail.gmail.com>
	 <20070421013454.GB4016@stusta.de>
	 <62eb359a0704202130p39cf24efu89dccc8437c30d25@mail.gmail.com>
	 <20070421053420.GA10974@suse.de> <20070421103632.GC4016@stusta.de>
	 <462C8525.76E4.0078.0@novell.com>
	 <62eb359a0704231558we55f553u44a77183ed3e5340@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm that reverting commit
7639e962234c76031d1ddf436def7fd9602be560 fixes the problem.  Also,
there seem to be plenty of other people reporting the same boot
locking:

http://groups.google.com/group/fa.linux.kernel/msg/cc0453677be44a9e
http://bbs.archlinux.org/viewtopic.php?pid=245313
http://bugs.archlinux.org/task/6845
http://www.usenetlinux.com/archive/topic.php/t-757515.html

Please consider reverting this patch in upstream.
Thank you for your time,
Marcos

On 4/23/07, Marcos Pinto <markybob@gmail.com> wrote:
> On 4/23/07, Jan Beulich <jbeulich@novell.com> wrote:
> > Given that all of the reports are in cases when the adjustment is *not*
> > being done (and only a message is being printed), I can only assume that
> > the breakage results from the adding of PCI_BASE_ADDRESS_SPACE_IO
> > into the resource flags. I considered this unconditional setting of the flags
> > odd already in the original code, and added this extra flag only for
> > consistency reasons (because the settings reported by X indicated that
> > this was missing). Perhaps the adjustment (original and the added
> > extra flag) shouldn't be done if IORESOURCE_IO wasn't already set.
> > Perhaps one of those seeing the issue could try out returning from the
> > function right after that printk(), without any adjustment to the flags.
> >
> > Jan
> >
> >
>

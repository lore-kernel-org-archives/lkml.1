Return-Path: <linux-kernel-owner+w=401wt.eu-S1755811AbYITBTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811AbYITBTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 21:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYITBTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 21:19:10 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:59117 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYITBTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 21:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=QyV1F5G7G7Qp9kEQz4rH4MKKHMgsFOStNHTDMCxycHwJccc/ZwGAV1EGqZvSzCL6dR
         ZqjW/pDOr9ePn66qOB6fSLfYpctmcR+BLonPKF57g3u8P3E1rZodIFclzJF6HkNxh1tY
         6YLexHOR21U4zlnSR+9lxPBrjqhw4Esaxb6QI=
Message-ID: <dd18b0c30809191819m39c4dfcbu22979daed9e94912@mail.gmail.com>
Date: Fri, 19 Sep 2008 18:19:08 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "David Brownell" <david-b@pacbell.net>
Subject: Re: [19.666764] Disabling IRQ #23
Cc: "Alan Stern" <stern@rowland.harvard.edu>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>, "Chris Snook" <csnook@redhat.com>,
       Linux-usb <linux-usb@vger.kernel.org>
In-Reply-To: <200809191756.18661.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30809190941g8b44175haf3e3a7c354fe01c@mail.gmail.com>
	 <dd18b0c30809191118u20a13ff3m801a23397eb6beed@mail.gmail.com>
	 <dd18b0c30809191420xe1ff525rbf59bb5d9f9910b2@mail.gmail.com>
	 <200809191756.18661.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 5:56 PM, David Brownell <david-b@pacbell.net> wrote:
> In
>
>  http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-02-usb.current/
>
> the patch
>
>  usb-fix-ehci-periodic-transfers.patch
>
> seems like it should resolve the root cause of this, and
>
>  usb-ehci-fix-some-ehci-hangs-and-crashes.patch
>
> would cover symptoms which probably caused the "Disabling..." message.
> Both patches were in that LKML thread you referenced.
>

Cool, I did apply that patch and the periodic patch as well,
after doing so the system did not report any disable irq #23
message., but after running these two for a few days without
any issues I reverted. Then looking more into my situation,
I think ehci_hcd was getting confused with one usb device being
created by udev, and then a few seconds later another device with the
same numbers
created by hal(if thats how those two work), causing ehci_hcd to freak out.
in any case; applying the patch you had mentioned, as well
as the periodic patch did make ehci_hcd accept the two(if thats what
was happening).

regards;

-- 
Justin P. Mattock

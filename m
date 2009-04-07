Return-Path: <linux-kernel-owner+w=401wt.eu-S1753321AbZDGXId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321AbZDGXId (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 19:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZDGXIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 19:08:22 -0400
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:36832 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751551AbZDGXIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 19:08:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RAP8ReLxflgC4wsIbmdYICJFhcdg8SU8tnGgQZF+ESvGdl+gT6K13c6xO+waLDYwhSWj5lWEie4xItXZkWWrQJx3rBGFOgGOrNV+LD8U7rnnvo7CvANWq9kQwBOKHXaw22u1WqVMBhJu7Kd2W2M5LKbt5iZ7hlNuXcNOPAgE0Js=  ;
X-YMail-OSG: qG4I.8UVM1lJorxNvOYpTLExPaMVjTlAm6MFG9TOuBSskLvWWVG8hfQKOZZ_U5m1FnueX8BKvcrQEwvG8loN1tUoa0xoO9.oEkwyFdkvigFAxjgytIVZnArqluK59JI1uSFmTVgOZIij1vLy53xmqvBYWxEL.KUE5mCGiAfAC6hYeHEQqzqsQAUz6XugPIUMzBzq8ExGllmgAbI5o4LxWztsCCICwvBzajDxy.kZyhdAbWNSFo.PVgozu9Q4NW7UIMfi3JSkv7SFOBoj44Z4xmjBKI4ECLiTxavOvshyrdMSbKQhc6tP
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>,
       "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>
Subject: Re: [PATCH] MTD-NAND: Changes to read_page APIs to support NAND_ECC_HW_SYNDROME mode on TI DaVinci DM355
Date: Tue, 7 Apr 2009 16:08:18 -0700
User-Agent: KMail/1.9.10
Cc: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1238601784-9563-1-git-send-email-nsnehaprabha@ti.com> <7A436F7769CA33409C6B44B358BFFF0CFFAA9253@dlee02.ent.ti.com> <alpine.LFD.2.00.0904072123320.21577@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904072123320.21577@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904071608.19123.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 April 2009, Thomas Gleixner wrote:
> What you need is a NAND_ECC_HW_OOB_FIRST mode, which uses the
> NAND_ECC_HW write function and implements a separate read function
> which reads the oob and then reads the data chunks.

That sounds about right, and it should address the issues
I raised earlier in this thread.

Though I might name it differently.  Reason being that the
"read OOB first" bit is only needed when there's more than
one ecc.step ... small page chips won't need it.  Maybe it
would suffice to map that mode to ECC_HW in those cases.

- Dave

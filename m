Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbYAUMsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbYAUMsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 07:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYAUMsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 07:48:23 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:57676 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880AbYAUMsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 07:48:23 -0500
Date: Mon, 21 Jan 2008 05:48:21 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Tejun Heo <htejun@gmail.com>
Cc: randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk, take #2
Message-ID: <20080121124821.GH27250@parisc-linux.org>
References: <1200892437108-git-send-email-htejun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200892437108-git-send-email-htejun@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2008 at 02:13:52PM +0900, Tejun Heo wrote:
> In a nutshell, printk_header() lets you do the following atomically
> (against other messages).
> 
>  code:
>   printk(KERN_INFO "ata1.00: ", "line0\nline1\nline2\n");
> 
>  output:
>   <6>ata1.00: line0
>   <6>         line1
>   <6>         line2

I think this is a really bad idea.  It's much better to have:

<6>ata1.00: line0
<6>ata1.00: line1
<6>ata1.00: line2

That way you can grep for ata1.00 and get all messages relevant to that
device.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbYAUNFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbYAUNFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 08:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYAUNFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 08:05:07 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:53400 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYAUNFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 08:05:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=tlQeAT+aQ7+RTnST7JnH6hfX+61a9Jft0WvC53ZRlvwh6yZmhmVfnlZiqbQ+JGieK3Z0WK5kilGo1yl5cGUJnIbm43c2gkWfdPS6tFgovtJ7RLlTFGXLKcJlQFIqVQ/PPC+UH6BMwdQ37Axsw4eVg1em3tlFL+4DFqcQLlh0Zmk=
Message-ID: <47949876.6070001@gmail.com>
Date: Mon, 21 Jan 2008 22:04:54 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: randy.dunlap@oracle.com, daniel.ritz-ml@swissonline.ch, jeff@garzik.org,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCHSET] printk: implement printk_header() and merging printk,
 take #2
References: <1200892437108-git-send-email-htejun@gmail.com> <20080121124821.GH27250@parisc-linux.org>
In-Reply-To: <20080121124821.GH27250@parisc-linux.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Mon, Jan 21, 2008 at 02:13:52PM +0900, Tejun Heo wrote:
>> In a nutshell, printk_header() lets you do the following atomically
>> (against other messages).
>>
>>  code:
>>   printk(KERN_INFO "ata1.00: ", "line0\nline1\nline2\n");
>>
>>  output:
>>   <6>ata1.00: line0
>>   <6>         line1
>>   <6>         line2
> 
> I think this is a really bad idea.  It's much better to have:
> 
> <6>ata1.00: line0
> <6>ata1.00: line1
> <6>ata1.00: line2
> 
> That way you can grep for ata1.00 and get all messages relevant to that
> device.

It has some pros and cons.  Having indentation makes things easier on
human eyes but more difficult on scripts, but not too difficult -
indented lines can easily be matched with a bit of scripting.  Changing
the behavior is easy but I'm still inclined toward indentation because
printing header every line loses information about message boundaries.
Maybe there's a way to satisfy both like omitting the separator from the
second line on.

ata1.00: line0
ata1.00  line1
ata1.00  line2

Hmm... Any better ideas?

-- 
tejun

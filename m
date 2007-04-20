Return-Path: <linux-kernel-owner+w=401wt.eu-S1767277AbXDTVkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767277AbXDTVkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 17:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161371AbXDTVkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 17:40:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:59207 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161332AbXDTVkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 17:40:01 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: how to tell linux (on x86) to ignore 1M or memory
To: Rene Herman <rene.herman@gmail.com>, Dave Jones <davej@redhat.com>,
       Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Kyle McMartin <kyle@canonical.com>, linux-kernel@vger.kernel.org,
       alan@redhat.com, bcollins@ubuntu.com, pjones@redhat.com
Reply-To: 7eggert@gmx.de
Date: Fri, 20 Apr 2007 23:39:54 +0200
References: <8bFEz-3B4-39@gated-at.bofh.it> <8c6EE-4Jj-5@gated-at.bofh.it>
User-Agent: KNode/0.7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1Hf0pe-0001Ne-J8@be1.lrz>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX19anbb+i+9DoDY9WiYjY2rXL7fDQ4HCECYJNMt
 iT0IRMlLydkU4OqVkYv8gPcf//FG0AeJRRTexS4tZ01z56EEoD
 d+nCry0iIs2ttE+8uN3qQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman <rene.herman@gmail.com> wrote:
> On 04/19/2007 04:18 PM, Bart Trojanowski wrote:

>> I need to preserve some state from the bios before entering protected
>> mode.  For now I want to copy it into some ram accessible by real-mode,
>> say the last megabyte visible in real-mode.
>> 
>> What's the easiest way to have linux ignore the megabyte starting at 15M?
> 
> Note that real-mode can only access the first megabyte (*) and not the first
> 16. 16MB is the 16-bit protected mode (286) limit.
> 
> (*) well, the first 1M + 64K - 16 bytes using segment FFFF assuming A20 is
> enabled and x > 1 in x86...

Interrupt 15h, function 87h allows copying from/to extended memory.
You might like to look into Ralph Brown's interrupt list for more details.

You could also cpio-gzip the data and append it to the initramfs.
-- 
Fun things to slip into your budget
Does that line item say 'Personal Massage System' Oops, it's supposed to be
'Message'. Go ahead and sign the authorization, Boss; I'll correct it later.
(Iike Hell I will)

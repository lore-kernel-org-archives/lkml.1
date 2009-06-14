Return-Path: <linux-kernel-owner+w=401wt.eu-S1755725AbZFNSC5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725AbZFNSC5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 14:02:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbZFNSCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 14:02:48 -0400
Received: from mail-px0-f187.google.com ([209.85.216.187]:55492 "EHLO
	mail-px0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZFNSCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 14:02:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:message-id:to:cc:subject:from:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=BZbKRPwcu7hb/5daElPKdo03+IDYLLpiMUYrohdOvzB1NLD53f1oJZpkOnYwlIrtfi
         zRemUuLnyYFg2IAMU366d1XWPMLF821NZU5HkCaESf5UX6lXLzvx6Jz5IrCdTX6DsvI5
         Q9823BvIwgC95N2fSMS3wULtL4svwNeET3Ijc=
Date: Mon, 15 Jun 2009 03:02:45 +0900 (JST)
Message-Id: <20090615.030245.104791670.konishi.ryusuke@gmail.com>
To: llucax@gmail.com
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       albertito@blitiri.com.ar, users@nilfs.org, llucax@gmail.com
Subject: Re: NILFS2 get stuck after bio_alloc() fail
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
In-Reply-To: <20090614153256.GA4020@homero.springfield.home>
References: <20090614013211.GA22552@homero.springfield.home>
	<20090614.124517.47505469.konishi.ryusuke@gmail.com>
	<20090614153256.GA4020@homero.springfield.home>
X-Mailer: Mew version 6.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Leandro,
On Sun, 14 Jun 2009 12:32:56 -0300, Leandro Lucarella wrote:
> Ryusuke Konishi, el 14 de junio a las 12:45 me escribiste:
>> Hi,
>> On Sat, 13 Jun 2009 22:32:11 -0300, Leandro Lucarella wrote:
>> > Hi!
>> > 
>> > While testing nilfs2 (using 2.6.30) doing some "cp"s and "rm"s, I noticed
>> > sometimes they got stucked in D state, and the kernel had said the
>> > following message:
>> > 
>> >         NILFS: IO error writing segment
>> > 
>> > A friend gave me a hand and after adding some printk()s we found out that
>> > the problem seems to occur when bio_alloc()s inside nilfs_alloc_seg_bio()
>> > fail, making it return NULL; but we don't know how that causes the
>> > processes to get stucked.
>> 
>> Thank you for reporting this issue.
>> 
>> Could you get stack dump of the stuck nilfs task?
>> It is acquirable as follows if you enabled magic sysrq feature:
>> 
>>  # echo t > /proc/sysrq-trigger
>> 
>> I will dig into the process how it got stuck.
> 
> Here is (what I thought it's) the important stuff:
<snip>
 
> 'rm' is the "original" stuck process, 'umount' got stuck after that, when I
> tried to umount the nilfs (it was mounted in a loop device).
> 
> Here is the complete trace:
> http://pastebin.lugmen.org.ar/4931

Thank you for your help.

According to your log, there seems to be a leakage in clear processing
of the writeback flag on pages.  I will review the error path of log
writer to narrow down the cause.

Regards,
Ryusuke Konishi

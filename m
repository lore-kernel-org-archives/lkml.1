Return-Path: <linux-kernel-owner+w=401wt.eu-S1754101AbZBIAHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754101AbZBIAHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 19:07:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbZBIAHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 19:07:10 -0500
Received: from h155.mvista.com ([63.81.120.155]:59193 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752988AbZBIAHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 19:07:09 -0500
Message-ID: <498F73A5.2070300@ru.mvista.com>
Date: Mon, 09 Feb 2009 03:07:01 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, rjw@sisk.pl
Subject: Re: [PATCH] libata-sff: fix 32-bit PIO regression
References: <200902082253.07438.sshtylyov@ru.mvista.com> <Pine.LNX.4.64.0902082108290.18661@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902082108290.18661@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Hugh Dickins wrote:

>> Commit 871af1210f13966ab911ed2166e4ab2ce775b99d (libata: Add 32bit PIO support)
>> caused all kind of errors on the ATAPI devices, so it's been empirically proven
>> that one shouldn't read/write an extra data word when a device isn't expecting
>> it already. "Don't do it then"; however still taking a chance to use 32-bit I/O
>> one last  time when there are exactly 3 trailing bytes.  Oh, and stop pointless
>> swapping bytes to and fro as well by using io*_rep() which shouldn't byte-swap.
>>
>> This should fix the kernel.org bug #12609.
>>
>> ---
>> This is hopefully better replacement for Hugh Dickins most recent patch
>> (http://marc.info/?l=linux-ide&m=123352294619281)...
>>     
>
> Yes, looks nice, and works for me.  My only criticism would be,
> minor issue unchanged by your patch, that actually "slop" isn't
> unlikely enough to deserve an "unlikely" - slop of 1 or 3 is
> unlikely, but slop of 2 is quite common.
>   

  Common on what types of ATAPI commands? I can hardly believe that they 
are common on the block I/O...

MBR, Sergei



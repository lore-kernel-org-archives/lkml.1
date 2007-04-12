Return-Path: <linux-kernel-owner+w=401wt.eu-S1161577AbXDLIN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161577AbXDLIN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 04:13:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161579AbXDLIN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 04:13:58 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:52202 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161577AbXDLIN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 04:13:57 -0400
Date: Thu, 12 Apr 2007 10:13:05 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Willy Tarreau <w@1wt.eu>
cc: Pedro <linux_user@izecksohn.com>, linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer
In-Reply-To: <20070411194820.GI943@1wt.eu>
Message-ID: <Pine.LNX.4.61.0704121011370.20436@yvahk01.tjqt.qr>
References: <200704110223.31291.linux_user@izecksohn.com> <20070411194820.GI943@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11 2007 21:48, Willy Tarreau wrote:
>On Wed, Apr 11, 2007 at 02:23:31AM -0300, Pedro wrote:
>>   After suffering some days from a not|mis configured tmpfs,
>> 
>>   As the OOM killer is not Posix,
>> 
>>   Better than to kill processes would be to resize tmpfs, to use tmpfs empty 
>> space.
>
>Will not work, because tmpfs does not use any memory for unused space. If
>you don't believe me, simply create a large file on your tmpfs, then check
>free memory, then remove the file and check free memory again.
>
>So your problem is not caused by the empty space on tmpfs, but either by
>too much space used on tmpfs or by your application using too much memory.
>
>>   I'm using kernel 2.6.20.4. If someone ask I'll send a test application.
>
>Not needed, the one-liner "main(){while(malloc(4096));}" is enough to
>trigger an OOM.

No, that won't do anything, malloc happily returns NULL after a few seconds.

int main()
{
	while(1) {
		char *p = malloc(4096);
		*p = 1;
	}
}

This is more likely to trigger OOM, because it actually dirties the page.


Jan
-- 

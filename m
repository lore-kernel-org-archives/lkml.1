Return-Path: <linux-kernel-owner+w=401wt.eu-S1753604AbYKAXHg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbYKAXHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 19:07:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbYKAXH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 19:07:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:7521 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbYKAXH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 19:07:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hn032Zpi+JXKSGYhhQUtjWyB+UZDe6rbJJAmnvYOIlDaNaMcRQxz6BT8ONXhIQwoih
         b2OD2lsQsbWWI2mugR0YCsqheNPnEwDh0WQlsMawti1QTRniBIhGTJnsjaFG+QXnoMap
         xn6h/8cqwjUBQlx1GxeeFbR698+SNx12AtGlQ=
Message-ID: <490CE128.3020007@gmail.com>
Date: Sun, 02 Nov 2008 00:07:20 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Jeroen Roovers <jer@gentoo.org>, Helge Deller <deller@gmx.de>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USBHID: correct start/stop cycle
References: <1225579306-28524-1-git-send-email-jirislaby@gmail.com> <alpine.LNX.1.10.0811020000360.29633@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0811020000360.29633@jikos.suse.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2008 12:02 AM, Jiri Kosina wrote:
> On Sat, 1 Nov 2008, Jiri Slaby wrote:
> 
>> `stop' left out usbhid->urb* pointers and so the next `start' thought
>> it needs to allocate nothing and used the memory pointers previously
>> pointed to. This led to memory corruption and device malfunction.
[...]
> could you please verify whether this patch fixes the corruption you were 
> experiencing?

btw. this is not expected to fix that, but if it does, the better ;).

This fixes
echo DEVICE > /sys/bus/hid/drivers/DRIVER/unbind
echo DEVICE > /sys/bus/hid/drivers/DRIVER/bind
failures.

But maybe parisc does something differently than x86 in bus handling so that it
triggers...

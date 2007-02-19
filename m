Return-Path: <linux-kernel-owner+w=401wt.eu-S932278AbXBSO1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbXBSO1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 09:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932280AbXBSO1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 09:27:17 -0500
Received: from il.qumranet.com ([82.166.9.18]:47816 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932278AbXBSO1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 09:27:17 -0500
X-Greylist: delayed 1299 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Feb 2007 09:27:17 EST
Message-ID: <45D9AE8D.4060300@argo.co.il>
Date: Mon, 19 Feb 2007 16:05:01 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: memparse(), simple_strtoul() prototypes...
References: <38b2ab8a0702180804l26d99a01y558bce2ee964d973@mail.gmail.com>	 <45D8EFB8.4050805@zytor.com> <38b2ab8a0702190503n32caeab3j2c2139c71cb5a9c5@mail.gmail.com>
In-Reply-To: <38b2ab8a0702190503n32caeab3j2c2139c71cb5a9c5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau wrote:
>> > unsigned long simple_strtoul(const char *cp, char **endp,unsigned 
>> int base)
>
> hm, I don't get your point. I understand why we cast 'cp' into a (char
> *) but that's not my point. My point is why aren't all function
> parameters are not const ?
>

'cp' can be passed as const, because simple_strtoul() does not modify 
it. 'endp' cannot be passed as const, because simple_strtoul() cannot 
know whether the caller would want to modify the string or not.

Whichever way it is written, it is broken.  If changed to 'const', it 
would preclude the caller from modifying the string if one has a 
non-const string.  As written, it can silently convert a const string to 
a non-const string.  However, as written it is (a) standard conforming, 
and (b) more useful.

-- 
error compiling committee.c: too many arguments to function


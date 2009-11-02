Return-Path: <linux-kernel-owner+w=401wt.eu-S1755139AbZKBMgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbZKBMgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 07:36:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755108AbZKBMgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 07:36:11 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:64853 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994AbZKBMgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 07:36:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ts8QVgCvRMV+DQLZo7Os95+4lkgbGSzqkGgDUMxfcivr6A65+88kC2K+XYg8NVBddn
         ZaI0eQfkBbf9Xnn8dTeYMKqzQ2Zjy7R6pHL9P82m126kBF+gFNLE/om9MJl3HVLa3r+S
         uD4YE6ijxEmI1yt7xtA9QCgFyvEENspw+mMP0=
Message-ID: <4AEED23A.7070009@gmail.com>
Date: Mon, 02 Nov 2009 07:36:10 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [net-next-2.6 PATCH RFC] TCPCT part 1d: generate Responder Cookie
References: <4AEAC763.4070200@gmail.com> <4AED86AD.6010906@gmail.com> <4AEDCD7C.2010403@gmail.com> <4AEEB6D2.7090505@gmail.com> <4AEEBAC6.7020308@gmail.com>
In-Reply-To: <4AEEBAC6.7020308@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> cookie_hash() runs in a non preemptable context. CPU cannot change under us.
> 
> (or else, we would not use __get_cpu_var(ipv4_cookie_scratch); )
> 
> And of course, each cpu gets its own scratch area, thanks to __get_cpu_var()
> 
Interesting.  I'm not sure that running CPU intensive functions like SHA1 in
a non-preemptable context is a good idea.  I'd assumed it wasn't!

Perhaps you could point at the documentation in the code that explains this?
Perhaps a function header comment that mentions it?

All I know is (from testing) that the tcp_minisockets.c caller is sometimes
called in a fashion that requires atomic allocation, and other times does not!

See my "Subject: query: tcpdump versus atomic?" thread from Oct 14th.

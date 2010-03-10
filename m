Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab0CJRTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 12:19:33 -0500
Received: from mail-qy0-f204.google.com ([209.85.221.204]:40097 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0CJRTc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 12:19:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OnuubruCmZ1O5Vs8YA12Roe0FirUtol9iI9CF94WgqhJ5I1ceBn7kAj5XFOH6sGzx4
         /erLwPJVOqg/KmWfYmfZdZJSyfm+z5W5V47Ppz3ekxBS6O20Nq/eo/L5coe3obF9RZcs
         VmuzV8YRDfa2IN8tZV+cfUeLxTyhRG44BHGUU=
MIME-Version: 1.0
In-Reply-To: <460422.78917.qm@web7603.mail.in.yahoo.com>
References: <460422.78917.qm@web7603.mail.in.yahoo.com>
Date: Wed, 10 Mar 2010 09:19:30 -0800
X-Google-Sender-Auth: 19ed1e0a139f463e
Message-ID: <1f1b08da1003100919k57d8cc6au6ff753ebf5b6c2f8@mail.gmail.com>
Subject: Re: BUG: Is it a bug in Linux time() function or Linux OS calls?
From: john stultz <johnstul@us.ibm.com>
To: Srinivas Nayak <sinu_nayak2001@yahoo.co.in>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 9, 2010 at 11:59 PM, Srinivas Nayak
<sinu_nayak2001@yahoo.co.in> wrote:
> I wrote a small program, that creates files at an interval of 1 minute. But the time at which the file is created and last written and the last modification time of the file as shown by ls command differs by 1 second. The code and the output is presented below. please let me know where could be the bug?
>
[snip]
> Some system info:
> ===========
> Linux new 2.6.24-19-server #1 SMP Wed Jun 18 14:44:47 UTC 2008 x86_64 GNU/Linux
> Gnu C                  4.2.4
> Linux C Library        2.7
> binutils               2.18.0.20080103
> util-linux             2.13.1
> Console-tools          0.2.3
> Sh-utils               6.10
> ===========

Hrm. Is CONFIG_NO_HZ enabled?  If so this is a known issue. The
filesystem timestamps use xtime, which is normally updated every HZ.
However to reduce overhead with NO_HZ we changed the update to be a
half-second, which can cause issues like what you describe.

The issue has since been resolved, so I'd be interested to hear if you
can still reproduce it on a more recent kernel.

thanks
-john

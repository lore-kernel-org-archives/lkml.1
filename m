Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab0BGGog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 01:44:36 -0500
Received: from mail-pz0-f187.google.com ([209.85.222.187]:48163 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337Ab0BGGoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 01:44:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S/miv7BvBT5Xe70Iqj3k29KSsn8PB9Fwed/un9jeQxLcC6E3LhFVgZUiArxdvaM9FM
         VCbBgbmia3yZsUW/+MOZF3+FJgvLIbCpnYqmlXErVIpk9UWgEHeXZYI3QhhuvjZLKo07
         oiB7eFz0cmrQs9eMwr+QrdHzG9DITw7csbivM=
Date: Sun, 7 Feb 2010 14:46:56 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, gregkh@suse.de,
       taviso@google.com, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       alan@lxorguk.ukuu.org.uk, jdike@addtoit.com, jln@google.com,
       mpm@selenic.com
Subject: Re: [2.6.33-rc5] tty: possible irq lock inversion dependency in
	tty_fasync
Message-ID: <20100207064643.GA15533@hack>
References: <201002071452.IIF73922.VtFOJOHSFFLOQM@I-love.SAKURA.ne.jp> <alpine.LFD.2.00.1002062226000.3829@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002062226000.3829@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 06, 2010 at 10:31:30PM -0800, Linus Torvalds wrote:
>
>
>On Sun, 7 Feb 2010, Tetsuo Handa wrote:
>> 
>> Below problem (which was introduced between 2.6.33-rc4 and 2.6.33-rc5) is
>> not yet fixed as of 2.6.33-rc7.
>> "git bisect start v2.6.33-rc5 v2.6.33-rc4" reported that
>> 703625118069f9f8960d356676662d3db5a9d116 tty: fix race in tty_fasync
>> is first bad commit.
>
>Yeah. I think we need to just revert that commit.
>
>Or maybe we could just do the following, rather than revert it outright: 
>just get a ref to the 'struct pid' while holding the spinlock, and then 
>releasing it after doing the __f_setown() call.

We already fixed this, a better fix:

http://lkml.org/lkml/2010/1/26/338

I sent a same fix with Greg's.

Thanks.

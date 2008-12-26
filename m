Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYLZJRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYLZJRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYLZJR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:17:26 -0500
Received: from ti-out-0910.google.com ([209.85.142.188]:15890 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYLZJRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:17:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=rrFKjXu/0gwVcYgrktKFRFUl9LlEaMCrYJd2u7CuPTGiW4GdMpBL+6x0NO9hIsNmwX
         7qa739JpQQ1jRGlJUqhCDSgOPmsxJ4psfrzsE8hmTv25pDqOW9VauHIj1JyPKgHK/3Y/
         AZyvkJ17EP0Wh8AHnM3hp7LU9SkQrRDT0YNWo=
Date: Fri, 26 Dec 2008 17:16:04 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] signal: let valid_signal() check more
Message-ID: <20081226171604.GE3156@hack.private>
References: <20081226012612.GI3130@hack.private> <20081225180054.GA24116@redhat.com> <20081226144928.GC3156@hack.private> <20081226085654.GE755@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081226085654.GE755@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 26, 2008 at 09:56:54AM +0100, Ingo Molnar wrote:
>
>* Américo Wang <xiyou.wangcong@gmail.com> wrote:
>
>> >> @@ -727,7 +727,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
>> >>  	{
>> >>  		if (!perm || !capable(CAP_KILL))
>> >>  			goto eperm;
>> >> -		if (!valid_signal(arg) || arg < 1 || arg == SIGKILL)
>> >> +		if (!valid_signal((int)arg) || arg == SIGKILL)
>> >                                  ^^^^^
>> >
>> >The patch adds a lot of unnecessary typecasts like this.
>> 
>> because it's inline?
>
>Why does your patch add a lot of seemingly unnecessary typecasts? [if your 
>short reply was supposed to be an answer to that question then please 
>explain it in more detail.]

Hi, Ingo.

because I also changed the type of valid_signal():

 -static inline int valid_signal(unsigned long sig)
 +static inline int valid_signal(int sig)

I noticed that gcc put this kind of warning into
-Wtraditional-conversion recently, but it is still useful to use
explicit cast, isn't it?

Thanks.

-- 
"Against stupidity, the gods themselves, contend in vain."


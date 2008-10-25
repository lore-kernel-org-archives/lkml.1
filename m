Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbYJYTib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbYJYTib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 15:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYJYTiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 15:38:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:23076 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbYJYTiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 15:38:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=TIV6ni1Jkn7NPFN5DRSDpLCKusxVizdypkkcufaTyPFy8c0bkwnpdCGO6+lm3otQum
         DXLe5df9Zn9A4P7z+0PshUUIqNvJ3X+uK+hocx+Wlbeio1LFUZDlm0Itf7WcCClg8yxW
         jO64iYALMslCPckE6YnyD9A4KWV4uqmdiFcwo=
Message-ID: <2c0942db0810251238u7eae212ct76af5c6d05126260@mail.gmail.com>
Date: Sat, 25 Oct 2008 12:38:22 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [2.6.28-rc1 regression] wmifinfo dockapp takes 100% of cpu (bisected)
Cc: "Marcin Slusarz" <marcin.slusarz@gmail.com>,
       "Carlos R. Mafra" <crmafra2@gmail.com>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081025121244.07cdd6d7@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081025094043.GA4438@localhost.aei.mpg.de>
	 <490327B6.2090903@linux.intel.com>
	 <20081025071348.63c426d9@infradead.org>
	 <20081025162503.GA4001@localhost.aei.mpg.de>
	 <20081025180322.GA10932@joi> <20081025121244.07cdd6d7@infradead.org>
X-Google-Sender-Auth: 6a68ecb385108ebe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 12:12 PM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Sat, 25 Oct 2008 20:03:27 +0200
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
>> > >           if (copy_from_user(&tv, tvp, sizeof(tv)))
>> > >                   return -EFAULT;
>> > >
>> > > +         while (tv.tv_usec > USEC_PER_SEC && i < 1000) {
>>                                   ^
>> should be >=
>
> yeah thanks for catching that. Note to self: don't code before coffee
>
> I'm not very happy with a while loop; but at least it solves the problem
>
> I'll try to make it nicer than this ...

Regardless, you may wish to make a set_normalized_timeval and place it
in kernel/time.c right after the current set_nromalized_timespec.
Comparing the two, you'll also want to handle the case where tv_usec
is negative.

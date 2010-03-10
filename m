Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752944Ab0CJKMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 05:12:47 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:51923 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751693Ab0CJKMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 05:12:42 -0500
Message-ID: <4B977067.3050108@st.com>
Date: Wed, 10 Mar 2010 15:41:51 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       armando.visconti@st.com, amit.goel@st.com, shiraz.hashim@st.com,
       vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
       ashish.priyadarshi@st.com
Subject: Re: [PATCH 04/11] ST SPEAr: Added basic header files for SPEAr 	platform
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-2-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-3-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-4-git-send-email-viresh.kumar@st.com>	 <1267592861-26911-5-git-send-email-viresh.kumar@st.com>	 <63386a3d1003092140o67a6c943rdee3a6c905cea7ef@mail.gmail.com>	 <4B973CF6.4030009@st.com> <63386a3d1003100131v7027e44cu5031c9ee3bf6ec73@mail.gmail.com>
In-Reply-To: <63386a3d1003100131v7027e44cu5031c9ee3bf6ec73@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/10/2010 3:01 PM, Linus Walleij wrote:
> 2010/3/10 Viresh KUMAR <viresh.kumar@st.com>:
>> Linus Walleij:
>>> If this file is only supposed to be used from plat-spear/time.c, move it down
>>> into plat-spear/gpt.h and #include "gpt.h" so noone else will
>>> accidentally use it.
>>
>> GPT's on SPEAr can be used from time.c, platform specific drivers and machine
>> specific drivers or any driver wishing to use hardware timer.
>> In first two cases "gpt.h" will work, but in rest of cases we need gpt.h to be
>> in plat-spear/include/plat
>>
>> Is it okay?
> 
> If you have or have already planned to write such platform, machine
> or subsystem drivers, it's OK, if there are no such users and you cannot
> easily give one, it's overdesigned IMHO. Some realistic examples of such
> drivers will make me change my mind :-)
> 
> The reason I persist is that I've seen such unutilized timer API:s before and
> no other user than the system timer in sight. I never understood what they
> were to be used for, and I still don't, so help me understand. The kernel
> has many internal timer API:s based on clockevent available already so
> why add yet another, platform-specific one?
> 

As you may have seen in spear.h files in mach folders, we have multiple hardware
timers in our design (3 in spear3xx, 4 in spear6xx and each timer have two
independent channels. That doubles the timers count, so it is 6 and 8).
One timer (or two channels) are used by clock event and clock source, but rest of
the timers are still available. So we need some way to export this functionality
of our hardware. It can be considered simply as a driver for GPT.

What do you say?

viresh.

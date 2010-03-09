Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932212Ab0CIDZR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 22:25:17 -0500
Received: from mail-pz0-f200.google.com ([209.85.222.200]:35851 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab0CIDZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 22:25:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ACFpeDJ6WDwqE3Kr/biVV7ArDsXNLH7Hw+vQfFND0+Os2JFmvIs/oN5VAMFRLU3S10
         j6oWKGraGfoHSik+bUtmEaO5UuIYtDBXMTpIO0ZPRBd0Q22+xU47YXCjCaJxR+j/HPGH
         zTXwN6cobp9WyDm9YRaHMeDaSFGkyGT+obhfs=
MIME-Version: 1.0
In-Reply-To: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
Date: Mon, 8 Mar 2010 19:25:07 -0800
X-Google-Sender-Auth: fea9b19159c097f9
Message-ID: <1f1b08da1003081925p61a810e4v96be56640287d61@mail.gmail.com>
Subject: Re: [PATCHv2 0/6] pps: time synchronization over LPT
From: john stultz <johnstul@us.ibm.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, linuxpps@ml.enneenne.com,
       "Nikita V. Youshchenko" <yoush@cs.msu.su>, stas@lvk.cs.msu.su,
       Rodolfo Giometti <giometti@enneenne.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 4:28 AM, Alexander Gordeev
<lasaine@lvk.cs.msu.su> wrote:
> This patchset is tested against the vanilla 2.6.32.9 kernel. But we are
> actually using it on 2.6.31.12-rt20 rt-preempt kernel most of the time.
> Also there is a version which should be applied on top of LinuxPPS out
> of tree patches (i.e. all clients and low-level irq timestamps stuff).
> Those who are interested in other versions of the patchset can find
> them in my git repository:
> http://lvk.cs.msu.su/~lasaine/timesync/linux-2.6-timesync.git
>
> There is one problem however: hardpps() works bad when used on top
> of 2.6.33-rc* with CONFIG_NO_HZ enabled. The reason for this is commit
> a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601. Without it hardpps() is able
> to sync to 1us precision in about 10 seconds. With it

Uh. Not sure I see right off why the logarithmic time accumulation
would give you troubles. Its actually there to try to fix a couple of
NTP issues that cropped up when the accumulation interval was pushed
out to 2HZ with CONFIG_NO_HZ.

Do you have any extra insight here as to whats going on with your
code?   The only thing I could guess would be second_overflow() is
happening closer to the actual overflow, but maybe less regularly? But
again, I'm not sure how this would be drastically different then
before with the 2HZ accumulation period.

thanks
-john

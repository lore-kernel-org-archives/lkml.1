Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZBJBlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZBJBlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 20:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZBJBlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 20:41:11 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:59837 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661AbZBJBlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 20:41:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=UJYNvhcnf02WE8Y47JFC/gEoyLoho2YwdpBkxHOqwFqoYvgmavIE2QO33ZRNe+i4Ai
         aFamCSRsUnFoGUsn6Q5HbnfDCdI/uvd974r/j5RB2IQatmtuw+2hGIm5Xm3Dvv9eSBj9
         +piUw9FVVL7Z9y8l7j2ETBeG+eV15TX2WUbs4=
MIME-Version: 1.0
In-Reply-To: <cc0fa41f0902091721r62b735d1i5ea89c0663075f6e@mail.gmail.com>
References: <cc0fa41f0902091721r62b735d1i5ea89c0663075f6e@mail.gmail.com>
Date: Mon, 9 Feb 2009 23:41:08 -0200
Message-ID: <cc0fa41f0902091741u40220b1cif47c7964010281c9@mail.gmail.com>
Subject: Re: cpufreq: last commit for 2.6.29 break cpufreq performance module
From: Guilherme Malschitzky Schroeder <guilherme.m.schroeder@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about the wrong info, i used the last cpufreq_ondemand.c file
before this commit and get the same problem. So it' s not the last
commit that changes the behaviour.
I'll bisect it and give more info.

On Mon, Feb 9, 2009 at 11:21 PM, Guilherme Malschitzky Schroeder
<guilherme.m.schroeder@gmail.com> wrote:
> Hello,
>
> After this commit 6707fbb56c8fd3121e334291d170934bcaca2e7f, if i
> change the governor of cpufreq to performance, my processor still
> shows 800MHz instead of 2268.
>
> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat scaling_governor
> ondemand
>
> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat cpuinfo_cur_freq
> 800000
>
> dub:/sys/devices/system/cpu/cpu0/cpufreq# echo performance > scaling_governor
> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat scaling_governor
> performance
> dub:/sys/devices/system/cpu/cpu0/cpufreq# cat cpuinfo_cur_freq
> 2267000
>
> But, /proc/cpuinfo shows 800MHz:
>
> model name      : Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz
> stepping        : 6
> cpu MHz         : 800.000
>
> And i cannot remove the ondemand module:
>
> dub:/sys/devices/system/cpu/cpu0/cpufreq# rmmod cpufreq_ondemand
> ERROR: Module cpufreq_ondemand is in use
>
> I can confirm that it's not on 2268MHz because glxgears runs below the expected.
>
> No errors on dmesg too.
>

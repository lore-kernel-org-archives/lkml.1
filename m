Return-Path: <linux-kernel-owner+w=401wt.eu-S1754920Ab0AMHfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab0AMHfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 02:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766Ab0AMHfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 02:35:41 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:42697 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab0AMHfl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 02:35:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Sj5VcsKXjHimVkkyKT1F9jyd7VpIxfxlxKxxEpbFT9E/dAU6PxMl1laoECfGNp7H7F
         3HlBwCOrMHpgQDM+H42OtNyzmFaUR8E4duSogNiak0i4XuzpPz9uqjg1LtCbyi8jdG7+
         dxh0cwDHdYv0UkjtaB3t49hecAUcX6pzr3+sQ=
MIME-Version: 1.0
In-Reply-To: <200912210955.00086.vl@fidra.de>
References: <200912071856.48125.vl@fidra.de> <4B1D8A27.6050008@kernel.org>
	 <200912080213.20502.vl@fidra.de> <200912210955.00086.vl@fidra.de>
Date: Tue, 12 Jan 2010 23:35:39 -0800
X-Google-Sender-Auth: 79bafbc3f79bd5d1
Message-ID: <86802c441001122335gda44dd2v93c613609dac7584@mail.gmail.com>
Subject: Re: [BISECTED, REGRESSION] Successful resume from suspend but freezes 
	after I/O
From: Yinghai Lu <yinghai@kernel.org>
To: Volker Lanz <vl@fidra.de>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 12:54 AM, Volker Lanz <vl@fidra.de> wrote:
> On Tuesday 08 December 2009 02:13:20 Volker Lanz wrote:
>> On Tuesday 08 December 2009 00:05:11 Yinghai Lu wrote:
>> > the updated e820 table is the same to the one for 2.6.29...
>> >
>> > so could be some other patch cause the problem.
>> >
>> > please check if revert
>> > 2547089ca2db132e307ef68848ba029a8ec2f341
>> > could help.
>>
>> I reverted to one commit before that, which would be
>> eaa959df299157e2640fcb3321537501b6afd9e6
>> if I am not mistaken. I built and booted that kernel and could reproduce
>>  the freeze with it (TBH this was not surprising to me, because I
>>  originally pinned down the problem by bisecting the commits and this
>>  commit is after the one bisecting found. Am I missing a detail here?)
>>
>> But strangely enough the freeze this time produced an oops before it locked
>> the machine. I couldn't save it to a file but took a picture. The
>>  screenshot is here:
>> http://banane.volker-lanz.de/08122009013.jpg
>> The oops is _not _reproducable. After a reboot with this same kernel, a
>> suspend/resume cycle and some I/O the machine locks again without showing
>>  the oops.
>>
>> Volker
>>
>
> Any news on this problem? Anything else I can do to help debug the situation?
> The prospect of being confined to distros with kernels < 2.6.29 for the next
> couple of years on this machine worries me, obviously.
>

as 6d794 said that is used fix exposed bug.
...
please checkout out

c61cf4cfe7c73c7aa62dde3ff82cd475b9c41481

and boot with debug.

YH

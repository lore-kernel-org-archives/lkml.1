Return-Path: <linux-kernel-owner+w=401wt.eu-S1756568AbZBJVdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568AbZBJVdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 16:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZBJVdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 16:33:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:1348 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbZBJVdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:33:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aX2laBbLs+YOpwOpSqdWekQnLAg2V9MUjRSvqIyMDSUifilZ1705swT5rgYIUQ2ahg
         byDzCJqdftqyX57n7j5seV48rqkc2Tih9qhu01/iK9uX6+fzW7CMgmZ4GkS+clkH2kjh
         6sxily/6TgigrMZjxVeO5TP7yTJxqEuchGYU8=
MIME-Version: 1.0
In-Reply-To: <cb7bb73a0902101328n25f64c9dqd6dabe62b05273ac@mail.gmail.com>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <498D9F02.9000107@tremplin-utc.net> <498E46F2.1020401@gmail.com>
	 <4990BE23.8080301@tremplin-utc.net> <4990DEFD.4010700@gmail.com>
	 <49915832.1090501@tremplin-utc.net>
	 <cb7bb73a0902100307m4eab8ff2nfe9be8bed6a3b5b5@mail.gmail.com>
	 <49917650.1060208@tudelft.nl>
	 <cb7bb73a0902101328n25f64c9dqd6dabe62b05273ac@mail.gmail.com>
Date: Tue, 10 Feb 2009 22:33:39 +0100
Message-ID: <cb7bb73a0902101333l4604e2f7r394f29a560ec27b0@mail.gmail.com>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: =?ISO-8859-1?Q?=C9ric_Piel?= <E.A.B.Piel@tudelft.nl>
Cc: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>,
       Palatis Tseng <palatis@gmail.com>, Pavel Machek <pavel@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 10:28 PM, Giuseppe Bilotta
<giuseppe.bilotta@gmail.com> wrote:
> On Tue, Feb 10, 2009 at 1:42 PM, Éric Piel <E.A.B.Piel@tudelft.nl> wrote:
>> Can you try something like this in lis3lv02d_poweron():
>>        adev.read(handle, CTRL_REG2, &val);
>>        val |= CTRL2_BDU | CTRL2_IEN;
>> +       val &= ~CTRL2_BLE;
>>        adev.write(handle, CTRL_REG2, val);
>
> Ok, this is getting crazier and crazier. Apparently, setting the
> CTRL2_BLE bit this way makes no difference, and so does setting it
> with val |= (i.e. enabling it): in both cases, if I debug
> lis3lv02d_read_16 I always get 0 in the lower byte and something in
> the upper byte.

To be precise, these are the result I get with some additional debug
info, with and without setting BLE.

Setting BLE on init:

[ 2891.428798] lis3lv02d: BLE: 0
[ 2891.452567] lis3lv02d: BLE: 32
[ 2891.476800] lis3lv02d: lo: 0 hi: 1
[ 2891.500616] lis3lv02d: lo: 0 hi: 3
[ 2891.524799] lis3lv02d: lo: 0 hi: 57

Resetting BLE on init:

[ 3006.661279] lis3lv02d: BLE: 0
[ 3006.684574] lis3lv02d: BLE: 0
[ 3006.709107] lis3lv02d: lo: 0 hi: 254
[ 3006.733144] lis3lv02d: lo: 0 hi: 2
[ 3006.757286] lis3lv02d: lo: 0 hi: 56

So it looks like (1) the BLE register is ignored (at least in my
sensor) and (2) it actually defaults to LE anyway.

-- 
Giuseppe "Oblomov" Bilotta

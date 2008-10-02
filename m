Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYJBWqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYJBWqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYJBWqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:46:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.228]:17711 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbYJBWqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=H1VYgakvbuMaKC8mZx0cHMm4vlDhu+BKtGpC/MiUa2iIeSs26b+N37Il2JySIkcl4X
         lbCrowgtu1I+syPO7ejvwaLQrbRDduR7sl10imLqXphMmgMk6dWIyMl3xEYuPKfosMVE
         HcnmkrMwj0KSwBObf71/Cmds/wrZ8bDaKwFag=
Message-ID: <86802c440810021546r6182a0c2id3566c1eb6ab7410@mail.gmail.com>
Date: Thu, 2 Oct 2008 15:46:20 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "=?ISO-8859-1?Q?J.A._Magall=F3n?=" <jamagallon@ono.com>
Subject: Re: [PATCH 2/2] x86: mtrr_cleanup try gran_size to less than 1M
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440810021539y6cdff33dh9df3e04eba85a9df@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
	 <1222739652-17169-2-git-send-email-yhlu.kernel@gmail.com>
	 <20081003003237.04469201@werewolf.home>
	 <86802c440810021539y6cdff33dh9df3e04eba85a9df@mail.gmail.com>
X-Google-Sender-Auth: 677b416bbb862ba4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2008 at 3:39 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Thu, Oct 2, 2008 at 3:32 PM, J.A. Magallón <jamagallon@ono.com> wrote:
>> On Mon, 29 Sep 2008 18:54:12 -0700, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>> Also, on a 64 bit box with 4Gb, it gives this:
>>
>> cicely:~# cat /proc/mtrr
>> reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>> reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>> reg02: base=0x140000000 (5120MB), size= 512MB: write-back, count=1
>> reg03: base=0x160000000 (5632MB), size= 256MB: write-back, count=1
>> reg04: base=0x80000000 (2048MB), size=2048MB: uncachable, count=1
>>
> boundary handling may have problem...

can you try

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index ef64128..70beb13 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -1044,7 +1044,7 @@ second_try:
                hole_sizek = range0_sizek - state->range_sizek - second_sizek;

                /* hole size should be less than half of range0 size */
-               if (hole_sizek > (range0_sizek >> 1) &&
+               if (hole_sizek >= (range0_sizek >> 1) &&
                    range0_sizek >= chunk_sizek) {
                        range0_sizek -= chunk_sizek;
                        second_sizek = 0;

YH

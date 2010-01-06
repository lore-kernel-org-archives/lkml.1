Return-Path: <linux-kernel-owner+w=401wt.eu-S1754921Ab0AFAVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab0AFAVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 19:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674Ab0AFAVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 19:21:13 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35195 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab0AFAVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 19:21:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=i9sTP9DM6M20D3JJeAAqcbvlF6WgNSC4/utdNfP4+BIYU0qIHVV2507/oXm+GDu4ZQ
         ODmnMfX7gzgjp5sqZjM50Hgbl1f79SKCeO7vV9xbiKNa3I2kgb6nRANNBtAYouGFgAdV
         LOES0dQfTSqBtUJPhb3Vy9UXZj3UV/jPWz1rM=
Message-ID: <4B43D753.90909@gmail.com>
Date: Wed, 06 Jan 2010 03:20:35 +0300
From: Eugene Kapun <abacabadabacaba@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); ru; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Does tkill/tgkill leak info from kernel stack?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I can see, tkill and tgkill syscalls call do_tkill (kernel/signal.c:2336).
This function doesn't clear info struct, so it would contain what was on kernel
stack previously. And because SI_TKILL < 0, precautions in copy_siginfo_to_user
(kernel/signal.c:2154) won't prevent this data from going to userspace. Is it a
bug?

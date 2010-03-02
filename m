Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab0CBXaW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:30:22 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:58813 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab0CBXaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:30:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=I2X7J8IHzTNGqd0xol8JdEshvYWf/xPf1VTKlzxe510LNPtTNaoCW9hj8lyt8/3hAM
         SMjrcuVdZrpH9GPleJVc7/3ZCYzhLuPSA0Hg7uVtAlRjN7OJ9kPGA13BLoZhzQJDPkSc
         FNuV3r/ZbWYxMuAqScz47dKoQ08q1B3+ZEejI=
Subject: Re: 2.6.33 problems
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, werner@guyane.dyn-o-saur.com,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <20100302144219.3cd28ae9@nehalam>
References: <1267290551.13148@guyane.dyn-o-saur.com>
	 <20100302135032.e3d11bbf.akpm@linux-foundation.org>
	 <20100302144219.3cd28ae9@nehalam>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Mar 2010 00:30:12 +0100
Message-ID: <1267572612.2839.70.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 02 mars 2010 à 14:42 -0800, Stephen Hemminger a écrit :


> The SNMP MIB stuff does allocate a disproportionately large amount of percpu
> data. Looks like 2 tables per MIB.

But did this percpu usage grew with 2.6.33 ?

In my understanding, ipv6 always wanted a lot of percpu data for its
MIBS (including per device MIBS), the big increase occurred with commit
96793b482540f3a26e2188eaf75cb56b7829d3e3
from David L Stevens, when RFC 4293 was implemented.
On IPV6, each net device needed 4096/8192 additional bytes of memory per
possible cpu.

An attempt to reduce SNMP mibs by 50% was attempted one ago, but not
completed. I'll try to find some time to resurrect the patch.

[RFC] percpu: convert SNMP mibs to new infra

(use one single table, for both user/bh contexts on x86)

http://lkml.org/lkml/2009/4/1/401



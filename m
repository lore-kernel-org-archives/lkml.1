Return-Path: <linux-kernel-owner+w=401wt.eu-S1752760AbZKAPR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbZKAPR6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 10:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZKAPR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 10:17:57 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:34222 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670AbZKAPR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 10:17:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:mime-version
         :content-type;
        b=bV4n0O1NGlF/2rjQwATJrbR+1zvWqLj6Cbn7Qv3El5oFokVsDCt7N3y8ZuMtuDdJCO
         hEIWlkGnim6OOObur9DW58TcxhETr0E1Cn2koardS8jmzPObzwCKhyoXiKEgTQpiJ2Mg
         +FUWL/jg93kF7yboo7ZHHVl5r401dAokxDWSs=
Date: Sun, 1 Nov 2009 23:17:55 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: wpa2 hangs v2.6.32-rc5-402-gb6727b1. Revert 7d930bc33653d5592dc386a76a38f39c2e962344
 fixed it.
Message-ID: <Pine.LNX.4.64.0911012306520.3549@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


wpa2 (wpa_supplicant) hangs v2.6.32-rc5-402-gb6727b1.

Reverting 7d930bc33653d5592dc386a76a38f39c2e962344 fixes it.

Here's the bad commit.

Thanks,
Jeff.



7d930bc33653d5592dc386a76a38f39c2e962344 is the first bad commit
commit 7d930bc33653d5592dc386a76a38f39c2e962344
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Oct 20 15:08:53 2009 +0900

     cfg80211: sme: deauthenticate on assoc failure

     When the in-kernel SME gets an association failure from
     the AP we don't deauthenticate, and thus get into a very
     confused state which will lead to warnings later on. Fix
     this by actually deauthenticating when the AP indicates
     an association failure.

     (Brought to you by the hacking session at Kernel Summit 2009 in Tokyo,
     Japan. -- JWL)

     Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
     Signed-off-by: John W. Linville <linville@tuxdriver.com>


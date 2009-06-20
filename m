Return-Path: <linux-kernel-owner+w=401wt.eu-S1754903AbZFTVW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903AbZFTVW0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 17:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751865AbZFTVWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 17:22:17 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58402 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbZFTVWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 17:22:16 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A3D5301.9010706@s5r6.in-berlin.de>
Date: Sat, 20 Jun 2009 23:22:09 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090523 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Sage Weil <sage@newdream.net>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       greg@kroah.com
Subject: Re: [PATCH 17/21] ceph: nfs re-export support
References: <1245450702-31343-1-git-send-email-sage@newdream.net> <1245450702-31343-4-git-send-email-sage@newdream.net> <1245450702-31343-5-git-send-email-sage@newdream.net> <1245450702-31343-6-git-send-email-sage@newdream.net> <1245450702-31343-7-git-send-email-sage@newdream.net> <1245450702-31343-8-git-send-email-sage@newdream.net> <1245450702-31343-9-git-send-email-sage@newdream.net> <1245450702-31343-10-git-send-email-sage@newdream.net> <1245450702-31343-11-git-send-email-sage@newdream.net> <1245450702-31343-12-git-send-email-sage@newdream.net> <1245450702-31343-13-git-send-email-sage@newdream.net> <1245450702-31343-14-git-send-email-sage@newdream.net> <1245450702-31343-15-git-send-email-sage@newdream.net> <1245450702-31343-16-git-send-email-sage@newdream.net> <1245450702-31343-17-git-send-email-sage@newdream.net> <1245450702-31343-18-git-send-email-sage@newdream.n! et> <4A3CA7FB.60707@s5r6.in-berlin.de> <Pine.LNX.4.64.0906201332410.2932@cobra.newdream.net>
In-Reply-To: <Pine.LNX.4.64.0906201332410.2932@cobra.newdream.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil wrote:
> I've done the same thing in a bunch of other places, too, the 
> big offender being decode.h, where e.g.
> 
> 		v = le64_to_cpu(*(__le64 *)*(p));	\
>                 *(p) += sizeof(u64);                    \
> 
> should be
> 
>                 v = le64_to_cpu(get_unaligned((__le64 *)*(p)));       \
>                 *(p) += sizeof(u64);                    \

Endian conversion and unaligned access can be combined, e.g.

		v = get_unaligned_le64(*p);

if p is a pointer to a pointer to an unaligned __le64.  These too come 
via <asm/unaligned.h> and are available since 2.6.26.
-- 
Stefan Richter
-=====-==--= -==- =-=--
http://arcgraph.de/sr/

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYGPT1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYGPT1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 15:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbYGPT13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 15:27:29 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:16958 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbYGPT12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 15:27:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=YzmuKyYsQMbIV6vipbx4ddURomfeET4jXkITSufWQ2dXeOb12cf5sqZhaZYFSs6ZXe
         bm5cWDRN+4hVBXNlzC9sqqC8OZP23JPHu9G4+kiZNsv4Om3S/iSvGLNMGc2KU1QzDHem
         dqwn1QZDcpgDpj/W/FMyQXKQKKkrAARnMd9SA=
Message-ID: <40f31dec0807161227n4254b8adobbbcfdde540704fd@mail.gmail.com>
Date: Wed, 16 Jul 2008 22:27:26 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 5/5] Ath5k: suspend/resume fixes
Cc: "Pavel Roskin" <proski@gnu.org>, "Jiri Slaby" <jirislaby@gmail.com>,
       linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <200807161141.59385.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
	 <200807160931.11473.jbarnes@virtuousgeek.org>
	 <1216229703.29744.23.camel@dv>
	 <200807161141.59385.jbarnes@virtuousgeek.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/16 Jesse Barnes <jbarnes@virtuousgeek.org>:
> On Wednesday, July 16, 2008 10:35 am Pavel Roskin wrote:
>> On Wed, 2008-07-16 at 09:31 -0700, Jesse Barnes wrote:
>> > On Wednesday, July 16, 2008 9:15 am Nick Kossifidis wrote:
>> > > It's ok for now, but have in mind that on my upcoming patch series i'm
>> > > disabling msi (commented out) since it results no interrupts on pci-e
>> > > cards (seems there is a bug in kernel's msi implementation).
>> >
>> > Hm, would be good to get details here.  MSI is being used by other
>> > drivers successfully...
>>
>> That's true, but no driver uses the same interrupt handler with and
>> without MSI.  Either it's different handlers or the handler checks if
>> MSI is enabled and does something differently.
>
> Yeah, using MSI on your device can mean that you have to make some changes
> (like on Intel graphics you have to disable regular interrupts or bad things
> happen), but you can still share the handler or at least most of it in some
> cases.
>

Is there documentation for this somewhere ? Msi documentation
(MSI-HOWTO.txt) doesn't say anything about a different interrupt
handler etc.

>> Checks is any interrupts are pending are different for MSI.  It may be
>> not hard to do (it's probably easier than for real interrupts), but it
>> has to be figured out.  Somebody has to do it right.  Until MSI is
>> supported by the interrupt handler, it should not be enabled by the
>> driver, or we get a non-functioning driver for AR5006.
>
> Sure, that's fine.  I just wanted to make sure that there weren't some weird
> generic MSI problems.
>

I was referring to this post...
http://lkml.org/lkml/2008/6/24/150


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick

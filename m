Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZHKTAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZHKTAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 15:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750840AbZHKTAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 15:00:13 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:59864 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988AbZHKTAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 15:00:12 -0400
Message-ID: <4A81BFBA.1070507@skyrush.com>
Date: Tue, 11 Aug 2009 13:00:10 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090722)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Artur Skawina <art.08.09@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Moving tty->stopped logic to ldisc (pty: fix data loss when stopped
 (^S/^Q))
References: <4A81B587.8070902@skyrush.com> <20090811185221.GA4750@suse.de>
In-Reply-To: <20090811185221.GA4750@suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Aug 11, 2009 at 12:16:39PM -0600, Joe Peterson wrote:
>> [Please include my email address in replies]
>>
>> Hi all,
>>
>> This is in regard to the problem that the recent patch ("pty: fix data
>> loss when stopped (^S/^Q)") fixes.  The issue is something I've been
>> looking at recently as well after noticing (I noticed it first as loss
>> of echoes, since I was re-testing what my echo buffer code originally
>> fixed).
> 
> Hm, is this resolved by git id 85dfd81dc57e8183a277ddd7a56aa65c96f3f487
> that Linus commited to the tree yesterday?

Well, that patch "fixes" the issue of the lost chars in that it resumes
previous behavior, but it does not address the two points I mentioned in
this post - ones that are hard to fix without moving checks for
tty->stopped to the ldisc or somehow locking the state of tty->stopped
(which seems a bit scary).  In other words, there still exist windows
for loss of chars.

						-Joe

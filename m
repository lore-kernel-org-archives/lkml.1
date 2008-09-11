Return-Path: <linux-kernel-owner+w=401wt.eu-S1754339AbYIKSfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339AbYIKSfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 14:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYIKSec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 14:34:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:62042 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbYIKSeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 14:34:31 -0400
Date: 11 Sep 2008 20:03:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: j@jannau.net
Cc: hch@infradead.org
Cc: jarod@redhat.com
Cc: jwilson@redhat.com
Cc: linux-kernel@vger.kernel.org
Cc: superm1@ubuntu.com
Message-ID: <AlfDbh7ojFB@christoph>
In-Reply-To: <200809101424.36654.j@jannau.net>
Subject: Re: [PATCH 01/18] lirc core device driver infrastructure
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/jwwV/NBqgzN2QEsHHG3O5CK22yRJ2CgeN58x
 LXPCxQSgnjW5LVKgtrAOi8td7Mv7fWAOni17pOeX2+WswRAOMt
 KD2b7CMFNHqwSxcGGdTNJjhIxc66roSMnK6j8/xzm4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Janne,

on 10 Sep 08 at 14:24, Janne Grunau wrote:
> On Tuesday 09 September 2008 15:01:02 Christoph Hellwig wrote:

>>> +	do {
>>> +		if (ir->open) {
>>> +			if (ir->jiffies_to_wait) {
>>> +				set_current_state(TASK_INTERRUPTIBLE);
>>> +				schedule_timeout(ir->jiffies_to_wait);
>>> +			} else {
>>> +				interruptible_sleep_on(
>>> +					ir->p.get_queue(ir->p.data));
>>> +			}
>>
>> No sleep on, please.  But this one should be trivial to fix anyway,
>> by just changing this to a
>>
>> 	set_current_state(TASK_INTERRUPTIBLE);
>> 	schedule();
>>
>> and using wake_up_process in the wakeup path.

> No driver uses the get_queue callback. So I'm inclined to just remove
> it. Christoph, any objections?

lirc_gpio is using it.
I guess there will be no need to use lirc_gpio in future, but I'd like to  
keep this in CVS for people who still use it.

Christoph

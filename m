Return-Path: <linux-kernel-owner+w=401wt.eu-S1758110AbYCJXQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110AbYCJXQu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbYCJXQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:16:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:34613 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYCJXQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:16:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Tx9rvlVGW4dRsMELJ5MmAe5CFwGXnrTmy3qaIhL7SckXhKoZOVyppr7/uVU4iqqiLTDCrsNH+mOZibSTHS4ma7SDr6sam9yU7n/UxocD2JRMbXQPcwY3FRM6IjumkWOHRHZT6pkssjZsb7PQcOTcCWnPPrw4lKCyb8yRsSeacck=
Message-ID: <47D5C14F.2060708@gmail.com>
Date: Tue, 11 Mar 2008 00:16:31 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty_ioctl: locking for tty_wait_until_sent
References: <20080310215325.2b8d33e8@core> <87od9m5iu4.fsf@basil.nowhere.org> <20080310220643.60f36bee@core> <20080310222835.GC9246@one.firstfloor.org>
In-Reply-To: <20080310222835.GC9246@one.firstfloor.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2008 11:28 PM, Andi Kleen wrote:
> On Mon, Mar 10, 2008 at 10:06:43PM +0000, Alan Cox wrote:
>> On 10 Mar 2008 23:12:51 +0100
>> Andi Kleen <andi@firstfloor.org> wrote:
>>
>>> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
>>>
>>>> This function still depends on the big kernel lock in some cases. Push
>>>> locking into the function ready for removal of the BKL from ioctl call
>>>> paths.
>>> Didn't you forget the .ioctl -> .unlocked_ioctl change?
>> We are not yet ready to unlock the device ioctl paths for tty. We still
> 
> Traditionally the usual is to first convert .ioctl to .unlocked_ioctl
> and just slap lock_kernel around the whole ioctl handler and then 
> later move it down step by step.
> 
> I didn't read the code completely but I assume tty_ioctl would be that
> handler. I guess i was wrong?

tty_ioctl is already unlocked_ioctl (in -mm) ;). These patches are those next 
steps to propagate the bkl down.

regards,
--js

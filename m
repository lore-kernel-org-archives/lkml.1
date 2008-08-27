Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbYH0ROW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbYH0ROW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYH0ROI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:14:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:49518 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbYH0ROG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Esf3bezuiDdMN8DmvhsOM1MvQtkj2D0dgTxBh/oFso0Xu/M9y8MkkfiS4rcC/ezcYP
         0waVZMTFpepBX0rkKf4OJXfz/usQX0OswhwoVNjIfcNbIR7Un8K6pe1WtJbGclcBaW+0
         f12vW3VfGQrhOuehOVehWEj62SP4VlXNRhkn0=
Message-ID: <48B58B77.2000101@gmail.com>
Date: Wed, 27 Aug 2008 19:14:31 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: Andi Kleen <andi@firstfloor.org>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Denys Fedoryshchenko <denys@visp.net.lb>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: loaded router, excessive getnstimeofday in oprofile
References: <200808220457.40892.denys@visp.net.lb>	<20080826201406.GA24827@2ka.mipt.ru>	<48B46B48.7030609@cosmosbay.com>	<20080826205158.GA15266@2ka.mipt.ru>	<87vdxmr53f.fsf@basil.nowhere.org> <20080827091706.574f2fae@extreme>
In-Reply-To: <20080827091706.574f2fae@extreme>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Hemminger wrote, On 08/27/2008 06:17 PM:

> On Wed, 27 Aug 2008 14:54:12 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
>> Evgeniy Polyakov <johnpol@2ka.mipt.ru> writes:
>>> Yup, this innocent toys can end up with this such behaviour on modern
>>> highly loaded machines.
>> I and also other people had some patches to move the time stamp
>> measuring into the socket. This way the time stamping didn't need to
>> be enabled on all packets, only on those that actually end up at a
>> socket that requires the time stamp.
>>
>> Unfortunately DaveM didn't like it because some bank wanted
>> different semantics, see the discussion in 
>> http://thread.gmane.org/gmane.linux.network/91679
>>
>> Perhaps you can find out which bank it was and send them a bill for
>> your CPU time ;-)
>>
>> -Andi
>>
> 
> Look at /proc/net/ptype to see if any AF_PACKET sockets are open.
> There are several causes of this:
>    * Applications like DHCP use AF_PACKET when they could use something else
>    * AF_PACKET API was poorly designed and always has timestamps
>    * The choice was made to get more accurate timestamps by stamping early in
>      receive code. A better alternative would be to do it in protocol handler
>      after the socket filter. Sorry, Andi socket layer is too late.
>    * No driver is using hardware mechanisms to get accurate/free timestamps.
>      I was working on sky2, but never was stable/complete.
> 
> Easist advice now is to fix userspace.

And what is working advice?

Why exactly admin can't chose between 2 alternatives here?

Jarek P.

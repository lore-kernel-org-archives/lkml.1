Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZLGSYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZLGSYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 13:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757857AbZLGSYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 13:24:42 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:56115 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757798AbZLGSYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 13:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=L/i1w19HBlHbqW+BTYflNrYh7WRXsPEwmOtc7GFxbHmR3d6IWxyhuvj/lLGnoFILgB
         KzzIXrsGT710189aWnLp1TWdEFrz8jS+v7B8RV10Rcw677+J0A51QqoGh3Lft0kPEPs5
         IsPgZNxDych5Jd+DeFf/VS0oSJlEmH6r9XYQM=
Date: Mon, 7 Dec 2009 10:24:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Emmanuel =?iso-8859-1?Q?Fust=E9?= <emmanuel.fuste@thalesgroup.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
	IR system?
Message-ID: <20091207182438.GB998@core.coreip.homeip.net>
References: <4B1D415F.5090308@thalesgroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B1D415F.5090308@thalesgroup.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 06:54:39PM +0100, Emmanuel Fusté wrote:
> Mauro Carvalho Chehab wrote:
>
>> In summary,
>>
>> While the current EVIO[G|S]KEYCODE works sub-optimally for scancodes up 
>> to 16 bytes
>> (since a read loop for 2^16 is not that expensive), the current approach
>> won't scale with bigger scancode spaces. So, it is needed expand it
>> to work with bigger scancode spaces, used by more recent IR protocols.
>>
>> I'm afraid that any tricks we may try to go around the current limits to still
>> keep using the same ioctl definition will sooner or later cause big headaches.
>> The better is to redesign it to allow using different scancode spaces.
>>
>>
>>   
> I second you: input layer events from drivers should be augmented with a
> protocol member, allowing us to define new ioctl and new ways to
> efficiently store and manage sparse scancode spaces (tree, hashtable
> ....).

Userspace has no business knowing how driver maps hardware data stream
into a keycode, only what is being mapped to what. The way is is done
can change from driver-to-driver, from release to release. If I come up
with an super-smart or super-stupid way of storing key mapping I won't
want to modify userpsace tools to support it.

> It will allow us to abstract the scancode value and to use
> variable length scancode depending on the used protocol, and using the
> most appropriate scheme to store the scancode/keycode mapping per protocol.
> The today scancode space will be the legacy one, the default if not
> specified "protocol". It will permit to progressively clean up the
> actual acceptable mess in the input layer and finally using real
> scancode -> keycode mappings everywhere if it is cleaner/convenient.
>

I am unable to parse this part, sorry.

-- 
Dmitry

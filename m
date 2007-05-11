Return-Path: <linux-kernel-owner+w=401wt.eu-S1761867AbXEKNwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761867AbXEKNwg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 09:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761422AbXEKNw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 09:52:28 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:31534 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbXEKNw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 09:52:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:openpgp:content-type:content-transfer-encoding;
        b=ec9wF4g4e9c7GkQ+qjlNggABadPnr7zsG/1/a354OB4sCHLSKHS+PjXu4kj/2OJ9gJvjLhPkjtB5cea6wqbX7MYFbJPRMqrMrM3FkctdrV5UpncBMiVvwdt8C6K5d2JEviOXs6yMrDEJKVEj1U9yLoqKNPiUIdV38cAng7a+/2E=
Message-ID: <46447509.7010305@gmail.com>
Date: Fri, 11 May 2007 19:22:09 +0530
From: jimmy bahuleyan <knight.camelot@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Johannes Stezenbach <js@linuxtv.org>
CC: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 2
References: <6143.1178828419@lwn.net> <464382DE.5020206@gmail.com> <20070511122113.GB15972@linuxtv.org>
In-Reply-To: <20070511122113.GB15972@linuxtv.org>
X-Enigmail-Version: 0.95.0
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Stezenbach wrote:
> On Fri, May 11, 2007 at 02:08:54AM +0530, jimmy bahuleyan wrote:
>> Jonathan Corbet wrote:
>> [snip..]
>>> +
>>> +  - The jiffies variable is special in that it can have a different value
>>> +    every time it is referenced, but it can be read without any special
>>> +    locking.  So jiffies can be volatile, but the addition of other
>>> +    variables of this type is strongly frowned upon.  Jiffies is considered
>>> +    to be a "stupid legacy" issue in this regard.
>> Why is it that you consider jiffies to be a "stupid legacy"? Isn't it
>> natural to have a externally modified variable which is only /read/ to
>> be volatile? (or is jiffies supposed to be replaced with something
>> smarter/better :)
> 
> "stupid legacy" were Linus' words. http://lwn.net/Articles/233482/
> 
> How about this:
> 
> "The jiffies variable is a special case because there are too
> many places in the kernel which would have to be changed and reviewed
> if the volatile would be removed from jiffies. However, the
> use of volatile qualifier for jiffies is just as wrong as
> it is elsewhere. Don't use jiffies as an excuse to use volatile
> in your code."
> 
> 
> Johannes
> 

yes this sounds better. at least to a non-kernel expert like me it makes
the meaning clear - 'that jiffies is a special case, not to be taken as
an example for other stuff'.

-jb

-- 
Tact is the art of making a point without making an enemy.

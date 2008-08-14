Return-Path: <linux-kernel-owner+w=401wt.eu-S1757660AbYHNILd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660AbYHNILd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbYHNILR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:11:17 -0400
Received: from sacred.ru ([62.205.161.221]:38790 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbYHNILP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:11:15 -0400
Message-ID: <48A3E81C.6010008@openvz.org>
Date: Thu, 14 Aug 2008 12:09:00 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Oren Laadan <orenl@cs.columbia.edu>
CC: Dave Hansen <dave@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [Devel] Re: [RFC][PATCH 1/4] checkpoint-restart: general	infrastructure
References: <20080807224033.FFB3A2C1@kernel>	 <20080807224034.735B1F84@kernel>	<200808081146.54834.arnd@arndb.de>	<1218221451.19082.36.camel@nimitz> <489CB3CA.6050304@cs.columbia.edu>
In-Reply-To: <489CB3CA.6050304@cs.columbia.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Thu, 14 Aug 2008 12:09:01 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oren Laadan wrote:
> 
> Dave Hansen wrote:
>> On Fri, 2008-08-08 at 11:46 +0200, Arnd Bergmann wrote:
>>> On Friday 08 August 2008, Dave Hansen wrote:
>>>> +	hh->magic = 0x00a2d200;
>>>> +	hh->major = (LINUX_VERSION_CODE >> 16) & 0xff;
>>>> +	hh->minor = (LINUX_VERSION_CODE >> 8) & 0xff;
>>>> +	hh->patch = (LINUX_VERSION_CODE) & 0xff;
>> ...
>>>> +}
>>> Do you rely on the kernel version in order to determine the format
>>> of the binary data, or is it just informational?
>>>
>>> If you think the format can change in incompatible ways, you
>>> probably need something more specific than the version number
>>> these days, because there are just so many different trees with
>>> the same numbers.
>> Yeah, this is very true.  My guess is that we'll need something like
>> what we do with modversions. 
> 
> Exactly. The header should eventually contain sufficient information
> to describe the kernel version, configuration, compiler, cpu (arch and
> capabilities), and checkpoint code version.

Sorry for late response - I was on vacation till Wednesday.

I am opposed against having *explicit* information about the kernel
configuration inside the image.

I see this like we store object images in a file, and these images do 
*not* change depending on the .config. But instead of this, at the time 
of restore we may *only* detect whether we can restore this type of
object or not.

E.g. consider we are saving a container image on ipv6 node and trying 
to restore from it on the one without the ipv6. In that case we *may*
have some object of for example CKPT_IPV6_IFA type of CLPT_IPV6_SOCK_INFO
and fail the restoration process when finding such in an input file. But 
what we should *not* do is to write any information about whether we had
the CONFIG_IPV6 turned on on the dumping side and check for this on the
restoring side.

(Sorry, if this question is already settled, but the discussion thread
 built by my mailer is a bit messy, so I suspect I could miss some part
 of the threads)

> How would you suggest to identify the origin tree with an identifier
> (or a text field) in the header ?

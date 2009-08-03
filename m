Return-Path: <linux-kernel-owner+w=401wt.eu-S932245AbZHCWB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbZHCWB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 18:01:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbZHCWB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 18:01:26 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:39682 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654AbZHCWBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 18:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sqshS9+5bjBrRuz0F4Ue+7Ed1o4PPgeu/sI+kK5Hez7aW+TUnFHXi3xyzyDmKGMOgN
         qokJFq5hAkgBo6Vw+NvcIka/QjBTT7Pzd0Sr668DIA+wWWmK7KvaMtisv2BcqLd2mHZL
         CPBC6qo2Ur9pAOc+hrl9CXHWpxrNRehC0bYjo=
MIME-Version: 1.0
In-Reply-To: <cb0375e10908031449l2005a468v9683eb5a078cf226@mail.gmail.com>
References: <cb0375e10908031414g471bacf5lab685958b60bfdfa@mail.gmail.com>
	 <20090803212015.GC28579@kroah.com>
	 <cb0375e10908031449l2005a468v9683eb5a078cf226@mail.gmail.com>
Date: Mon, 3 Aug 2009 18:01:24 -0400
X-Google-Sender-Auth: 434daf997d98a42c
Message-ID: <cb0375e10908031501w610d1e27ya69d7c2011f93555@mail.gmail.com>
Subject: Re: Is anyone maintaining (or even using) usbtmc?
From: Andrew Lutomirski <luto@mit.edu>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 5:49 PM, Andrew Lutomirski<luto@mit.edu> wrote:
> On Mon, Aug 3, 2009 at 5:20 PM, Greg KH<greg@kroah.com> wrote:
>> On Mon, Aug 03, 2009 at 05:14:56PM -0400, Andrew Lutomirski wrote:
>>> Hi all-
>>>
>>> I'm trying to use usbtmc on an Aglient N9310A (The only TMC device I
>>> have), and it sort of works, but it seems to be both extremely buggy
>>> and missing a good deal of rather important functionality.  Is there
>>> anyone maintaining it?
>>
>> Yes, me.
>>
>>> If the answer is yes, I can describe the bugs (logspam, spurious
>>> errors, delayed messages, inability to read status, etc.) in greater
>>> detail.
>>
>> Please do, but also please use the latest version, in 2.6.30.3, we fixed
>> some bad problems in it recently.
>
> I am.
>
> Almost anything I do triggers this:
>
> usbtmc 3-1:1.0: Unable to read data, error -110
>
> The easiest way is to write something that wasn't a query and then try
> to read.  Of course, the read should fail, but there's no reason it
> should spam the logs.

Here's more details, in the form of an strace log:

open("/dev/usbtmc0", O_RDWR|O_EXCL)     = 3
ioctl(3, 0x5b07, 0)                     = 0  // CLEAR_OUT_HALT
ioctl(3, 0x5b06, 0)                     = 0  // CLEAR_IN_HALT
ioctl(3, 0x5b02, 0)                     = 0  // CLEAR
write(3, "*IDN?\n", 6)                  = 6
read(3, 0x2078554, 4096)                = -1 ETIMEDOUT (Connection timed out)

Removing the \n makes no difference.  This happens over and over.

Then I used a different program that opened the device, read and
discarded some ETIMEDOUTs, and made a successful query (not quite sure
what did the trick), and the original program starts working again.

--Andy

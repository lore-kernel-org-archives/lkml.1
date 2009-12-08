Return-Path: <linux-kernel-owner+w=401wt.eu-S1755697AbZLHOsJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697AbZLHOsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 09:48:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbZLHOsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 09:48:08 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:45486 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbZLHOsH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 09:48:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lH5K166zd6Y0vVg9y/vZpl9uJpl9srK2Y1ShvmtGdJckVQZYPRf5pvUFB13MGgyiSY
         M+wUZhj6tOqUHrdxXozRGcDVCmBTaG8IQz9quAPK/6pglEDslCI9sCE5SJHECGgw3sy4
         xF9W4j5dYVVYLT7jAAm20eZwQgd/q4j/J/y3U=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0912080922160.3046-200000@iolanthe.rowland.org>
References: <4B1D7BB1.5040709@gmail.com>
	 <Pine.LNX.4.44L0.0912080922160.3046-200000@iolanthe.rowland.org>
Date: Tue, 8 Dec 2009 15:48:13 +0100
Message-ID: <14add3d10912080648w5610d533h2cf08a9d79fa48c1@mail.gmail.com>
Subject: Re: REGRESSION for RT2561/RT61 in 2.6.32
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Ivo van Doorn <IvDoorn@gmail.com>, linux-wireless@vger.kernel.org,
       Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 8, 2009 at 3:27 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 7 Dec 2009, Gertjan van Wingerde wrote:
>
>> > While the system is hung, Alt-SysRq-keys still work but nothing else
>> > shows up when I type (using a VT console, not X).  However I don't know
>> > what debugging to do or what to look for.
>> >
>> > Under 2.6.31 everything works okay.
>> >
>>
>> Hmmm, that's odd. I haven't seen any other reports on this (on full system hangs that is).
>>
>> It would be very hard to figure out what is going wrong without any form of logging of
>> an oops or something. Is there any way you can find out if any oops information is present?
>
> There is no oops.  The system just stops responding to keystrokes other
> than Alt-SysRq-*.
>
>> What does Alt-SysRq-l tell us, what are the CPU's doing when the system is hung?
>
> Unfortunately Alt-SysRq-l wasn't very helpful.  The output is below
> (captured using a serial console), starting from when I configured the
> wireless interface.  For thoroughness I have also attached the output
> of Alt-SysRq-T in single-user mode, but it doesn't seem to contain
> anything striking.
>
> Could the problem be connected with CONFIG_4KSTACKS (which was enabled
> in this kernel)?

Hmm, the stack overrun seems to be generated as part of the
Alt-SysRq-* handling, not of any rt61pci handling.

I noticed in the Alt-SysRq-T output that powersaving is enabled. We've
seen some strange behaviour on this, so could you disable that with:

iwconfig wlan0 power off

or run a kernel in which CONFIG_CFG80211_DEFAULT_PS is disabled.

Maybe that will fix the problem we are seeing?

Other than that I have no ideas on what is happening here.

---
Gertjan.

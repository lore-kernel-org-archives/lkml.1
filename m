Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbXDKS3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbXDKS3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXDKS3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:29:08 -0400
Received: from [212.12.190.25] ([212.12.190.25]:36115 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753554AbXDKS3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:29:06 -0400
From: Al Boldi <a1426z@gawab.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH 0/30] Use menuconfig objects
Date: Wed, 11 Apr 2007 21:32:36 +0300
User-Agent: KMail/1.5
Cc: linux-kernel@vger.kernel.org
References: <200704110112.39425.a1426z@gawab.com> <200704110742.38727.a1426z@gawab.com> <Pine.LNX.4.61.0704110937060.32056@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704110937060.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200704112132.36542.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 11 2007 07:42, Al Boldi wrote:
> >Jan Engelhardt wrote:
> >
> >Correct, no oversight here; but it may be more meaningful, if you could
> >default select child-options based on the parent-state, like HW_RANDOM.
>
> A symbol will already have the 'magic' you describe if its creator wrote
> it that way. Changing to 'menuconfig' tokens does not change that I
> think. Consider:
>
> menu "foobar"
> config FOOBAR
>   bool "foobar"
>   default y
>
> config HW_RANDOM
>   depends on FOOBAR
>   default y
>
> endmenu
>
> This example should do things as you describe -- if FOOBAR is changed
> from n to y, HW_RANDOM should automatically do the same since it is a
> new option then.

I don't think so. But this might:

menu "foobar"
 config FOOBAR
   bool "foobar"
   default y

 config HW_RANDOM
   depends on FOOBAR
   default FOOBAR

endmenu

>
> menuconfig FOOBAR
>   bool "foobar"
>   default y
>
> if FOOBAR
>
> config HW_RANDOM
>   default y
>
> endif
>
> inhibits the same behavior AFAICS.

I think you mean "exhibits"?

>
> >Also, I don't think it's necessary to touch any of the "depends on"; keep
> >them as is, as they don't hurt staying that way, and may actually be
> >necessary under certain circumstances.  (see EMBEDDED)
>
> Simplifying the depends lines is a good thing IMO.

You are replacing the depends with an if block, which seems to add 
complexity, as we now have two constructs, if and depends.

IMHO, leave the depends as is, for simplicity and correctness and 
maintainability.

So if we have something like this:

menu "foobar"
 config FOOBAR
   bool "foobar"
   default y

 config FOOBAR_SUB1
   tristate "FOOBAR SUB1"
   depends on FOOBAR
   default m

 config FOOBAR_SUB2
   bool "FOOBAR SUB2"
   depends on FOOBAR
   default y

endmenu

Change it to something like this:

menuconfig FOOBAR
   tristate "foobar"
   default y

 config FOOBAR_SUB1
   tristate "FOOBAR SUB1"
   depends on FOOBAR
   default FOOBAR

 config FOOBAR_SUB2
   bool "FOOBAR SUB2"
   depends on FOOBAR
   default FOOBAR

without any if blocks, and maybe even in its own Kconfig.


Thanks!

--
Al

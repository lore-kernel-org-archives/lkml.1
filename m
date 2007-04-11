Return-Path: <linux-kernel-owner+w=401wt.eu-S1751025AbXDKHsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751025AbXDKHsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXDKHsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:48:40 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:52236 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbXDKHsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:48:39 -0400
Date: Wed, 11 Apr 2007 09:48:21 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Al Boldi <a1426z@gawab.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/30] Use menuconfig objects
In-Reply-To: <200704110742.38727.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.61.0704110937060.32056@yvahk01.tjqt.qr>
References: <200704110112.39425.a1426z@gawab.com>
 <Pine.LNX.4.61.0704110026250.32056@yvahk01.tjqt.qr> <200704110742.38727.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11 2007 07:42, Al Boldi wrote:
>Jan Engelhardt wrote:
>
>Correct, no oversight here; but it may be more meaningful, if you could 
>default select child-options based on the parent-state, like HW_RANDOM.

A symbol will already have the 'magic' you describe if its creator wrote 
it that way. Changing to 'menuconfig' tokens does not change that I 
think. Consider:

menu "foobar"
config FOOBAR
  bool "foobar"
  default y

config HW_RANDOM
  depends on FOOBAR
  default y

endmenu

This example should do things as you describe -- if FOOBAR is changed 
from n to y, HW_RANDOM should automatically do the same since it is a 
new option then.

menuconfig FOOBAR
  bool "foobar"
  default y

if FOOBAR

config HW_RANDOM
  default y

endif

inhibits the same behavior AFAICS.

>Also, I don't think it's necessary to touch any of the "depends on"; keep 
>them as is, as they don't hurt staying that way, and may actually be 
>necessary under certain circumstances.  (see EMBEDDED)

Simplifying the depends lines is a good thing IMO.


Jan
-- 
